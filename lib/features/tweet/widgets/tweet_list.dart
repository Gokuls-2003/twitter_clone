import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_cart.dart';
import 'package:twitter_clone/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
      data: (tweets){ 

        return ref.watch(getLatestTweetProvider).when(
          data: (data){
            if(data.events.contains(
              'databases.*.collections.${AppWriteConstants.tweetscollection}.documents.*.create'
              )){
                tweets.insert(0, Tweet.fromMap(data.payload));
              }else if(data.events.contains(
              'databases.*.collections.${AppWriteConstants.tweetscollection}.documents.*.update'
              )) {
                print(data.events[0]);

                // var tweet = Tweet.fromMap(data.payload);
                // final tweetId = tweet.id;
                
                final startingPoint = data.events[0].lastIndexOf('documents.');
                 
                final endingPoint = data.events[0].lastIndexOf('.update');

                final tweetId = data.events[0].substring(startingPoint + 10, endingPoint);

                var tweet = tweets
                  .where((element) => element.id == tweetId)  
                  .first;
          
                final tweetIndex = tweets.indexOf(tweet);
                tweets.removeWhere((element) => element.id == tweetId);

                tweet = Tweet.fromMap(data.payload);
                tweets.insert(tweetIndex, tweet);
              }
              return ListView.builder(
                itemCount: tweets.length  ,
                itemBuilder: (BuildContext context, int index){
                  final tweet = tweets[index];
                  return TweetCart(tweet: tweet);
          }
          );
          },
            error: (error, stackTrace) => 
          ErrorText(error: error.toString()),
           loading: (){
             return ListView.builder(
                itemCount: tweets.length  ,
                itemBuilder: (BuildContext context, int index){
                  final tweet = tweets[index];
                  return TweetCart(tweet: tweet);
          }
          );
           }
           );
       
      },
      error: (error, stackTrace) => 
          ErrorText(error: error.toString()),
      loading: () => Loader()
      );
  }
}