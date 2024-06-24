import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/features/user_profile/widget/follow_count.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/pallate.dart';

class UserProfile extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
  builder: (context) =>  UserProfileView(userModel: userModel,)
  );

  final  UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser  = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null?  const Loader() : NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled)   {
         return [
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              snap: true,
              flexibleSpace: Stack(
                 children: [
                   Positioned.fill(
                  child: user.bannerPic.isEmpty ? Container(
                  color: Pallete.blueColor,
                 ) 
                 : Image.network(user.bannerPic) ),
                 Positioned(
                  bottom:10,
                  left: 10,
                   child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                    radius:45,
                   ),
                 ),
                 Container(
                  alignment: Alignment.bottomRight,
                  margin:  EdgeInsets.all(20),
                   child: OutlinedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Pallete.whiteColor, width: 1.5)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25)
                    ),
                    child: Text(
                      currentUser.uid == user.uid ? 'Edit Profile' :
                      "Follow",
                       style: TextStyle(
                        color: Pallete.whiteColor
                       ),)),
                 )

                 ]
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverList(delegate: SliverChildListDelegate(
                [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "@${user.name}",
                    style: TextStyle(
                      fontSize: 17,
                      color: Pallete.greyColor
                    ),
                  ),
                   Text(
                    user.bio,
                    style: TextStyle(
                      fontSize: 17,
                      color: Pallete.greyColor
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(children: [
                    FollowCount(count: user.following.length, text: 'Followers'),
                    const SizedBox(width: 15,),
                    FollowCount(count: user.followers.length, text: 'Followers')
                  ],),
                  const SizedBox(height: 2,),
                  const Divider(
                    color: Pallete.whiteColor,
                  )
                ]
              )),
            )
         ];
      },
      body: Container()
    );
  }
}