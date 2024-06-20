import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_cart.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
      data: (tweets){
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
      loading: () => Loader()
      );
  }
}