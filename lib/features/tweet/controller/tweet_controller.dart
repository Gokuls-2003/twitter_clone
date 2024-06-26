import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/enum/notification_type_enum.dart';
import 'package:twitter_clone/enum/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier)
    );
});

final getRepliesToTweetProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getLatestTweetProvider = StreamProvider((ref)  {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});


final getTweetByIdProvider = FutureProviderFamily((ref, String id) async{
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);    
});


class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  final NotificationController _notificationController;
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController
    }) : _ref = ref,  
         _tweetAPI = tweetAPI,
         _storageAPI = storageAPI,
         _notificationController = notificationController,
     super(false);

    Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
    }

    Future<Tweet> getTweetById(String id) async{
      final tweet = await _tweetAPI.getTweetById(id);
      return Tweet.fromMap(tweet.data);
    }

  void likeTweet(Tweet tweet, UserModel user)async {
  
   List<String> likes = tweet.likes;

   if(tweet.likes.contains(user.uid)){
      likes.remove(user.uid);
   }else{
    likes.add(user.uid);
   }
  tweet = tweet.copyWith(likes : likes);
  final res = await _tweetAPI.likeTweet(tweet); 
  res.fold((l) => null, (r) 
  {
   _notificationController.createNotification(
    text: '${user.name} like  your tweet',
    postId: tweet.id,
    notificationType: NotificationType.like,
    uid: tweet. uid
    );
  });

  }

  void  reShareTweet(Tweet tweet, UserModel currentUser, BuildContext context )async {
   tweet = tweet.copyWith(
     retweetedBy: currentUser.name,
     likes: [],
     commentIds: [],

     reshareCount: tweet.reshareCount+1, 
   );
    
   final res = await _tweetAPI.updateReshareCount(tweet);
  res.fold(
    (l) => ShowSnackBar(context, l.message), 
    (r) async{
      tweet = tweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
        tweetedAt: DateTime.now()
      );
      final res2 = await _tweetAPI.shareTweet(tweet);
      res2.fold((l) => ShowSnackBar(context, l.message), (r) => ShowSnackBar(context, 'Retweeted!'));
    } );
  }
  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }){
    if(text.isEmpty){
      ShowSnackBar(context, 'Please enter text');
      return;
    }
    if(images.isNotEmpty){
       _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    }else{
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    }
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _tweetAPI.getRepliesToTweet(tweet);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }
  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  })async{
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user =  _ref.read(currentUserDetailsProvider).value!;
    final imageLinks= await _storageAPI.uploadImage(images);
   Tweet tweet  = Tweet(
    text: text,
    hashtags: hashtags,
    link: link,
    imageLinks: imageLinks,
    uid: user.uid,
    tweetType: TweetType.image,
    tweetedAt: DateTime.now(),
    likes: const [],
    commentIds: const [],
    id: '',
    reshareCount: 0,
    retweetedBy: '',
    repliedTo: repliedTo
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state= false;
    res.fold((l) => ShowSnackBar(context, l.message), (r) => null);
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
     required String repliedTo,
  })async{
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user =  _ref.read(currentUserDetailsProvider).value!;
   Tweet tweet  = Tweet(
    text: text,
    hashtags: hashtags,
    link: link,
    imageLinks: const [],
    uid: user.uid,
    tweetType: TweetType.text,
    tweetedAt: DateTime.now(),
    likes: const [],
    commentIds: const [],
    id: '',
    reshareCount: 0,
    retweetedBy: '',
    repliedTo: repliedTo
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state= false;
    res.fold((l) => ShowSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text){
    String link ='';
    List<String> wordsInSentence = text.split(' ');
    for(String word in wordsInSentence){
      if(word.startsWith("htpps://") || word.startsWith("www.")){
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text){
    List<String> hashtags =[];

    List<String> wordsInSentence = text.split(' ');
    for(String word in wordsInSentence){
      if(word.startsWith("#")){
        hashtags.add(word);
      }
    }
    return hashtags;
  }


}