import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/home/widgets/side_drawer.dart';
import 'package:twitter_clone/features/tweet/views/create_tweet_view.dart';
import 'package:twitter_clone/theme/theme.dart';


class HomeView extends StatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => const HomeView());
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page =0;
  final appBar = UiConstants.appBar();
 
  void OnPageChange(int index){
    setState(() {
      _page = index;
    });
  }
  
  onCreateTweet(){
    Navigator.push(context, CreateTweetScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: IndexedStack(
        index: _page,
        children: UiConstants.bottomTabBarPage,
      ),
      floatingActionButton: FloatingActionButton(onPressed: onCreateTweet,
      child: const Icon(
        Icons.add,
        color: Pallete.whiteColor,
        size: 28,
      ),
    ),
     drawer: const SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: OnPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page ==0
              ?AssetsConstants.homeFilledIcon
              :AssetsConstants.homeOutlinedIcon,
              color: Pallete.whiteColor,                                
            )
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              color: Pallete.whiteColor,
            )
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page ==2
              ? AssetsConstants.notifFilledIcon
              : AssetsConstants.notifOutlinedIcon,
              color: Pallete.whiteColor,
            )
          )
        ],
      ),
    );

  }
}

