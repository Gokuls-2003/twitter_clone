import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/features/explore/view/explore_view.dart';
import 'package:twitter_clone/features/notification/views/notification_view.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_clone/theme/theme.dart'; 
class UiConstants{
  static AppBar appBar(){
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
        ),
        centerTitle: true,
    );
  }

 static  List<Widget> bottomTabBarPage = const[
            TweetList(),
            ExploreView(),
            NotificationView(),
 ];

}