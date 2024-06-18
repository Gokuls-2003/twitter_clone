import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/theme/pallate.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => const CreateTweetScreen());
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    // final currentUser = "66715fb46a4c26d7adc9";
    print(currentUser);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.close, size: 30,
          ),
        ),
        actions: [
          RoundedSmallButton(onTap: (){}, label: "Tweet", 
          backgroundColor: Pallete.blueColor,
          textColor: Pallete.whiteColor,
          )
        ],
      ),
      body: currentUser == null 
       ? const Loader()
       :  SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                   backgroundImage: NetworkImage(currentUser.profilePic),
                   radius: 30,
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}