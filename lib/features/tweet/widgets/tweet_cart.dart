import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/enum/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/pallate.dart';

class TweetCart extends ConsumerWidget {
  final Tweet tweet;
  const TweetCart({
    super.key,
    required this.tweet
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch( 
      userDetailsProvider(tweet.uid))
      .when(
        data: (user){
          return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 35,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //retweeted
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Text(
                                  user.name,
                                  style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                      fontSize: 19
                                      ),),
                              ),
                              Text(
                                  '@${user.name} . ${timeago.format(
                                    tweet.tweetedAt,
                                    locale: 'en_short'
                                    )
                                    }',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Pallete.greyColor
                                      ),),
                            ],
                          ),
                          //reply 
                          HashtagText(text: tweet.text),
                          if(tweet.tweetType == TweetType.image)
                          CarouselImage(imageLinks: tweet.imageLinks),
                          if(tweet.link.isNotEmpty) ...[
                            const SizedBox(height: 4,),
                            AnyLinkPreview(link: 'https://${tweet.link}' ),
                          ],
                          
                        ],
                      ),
                    )
                  ],
                )
              ],
          );
        },
        error: (error, stackTrace) => (
          ErrorText(error: error.toString(),)
        ),
        loading: () => const Loader());
       
  }
}