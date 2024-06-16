import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallate.dart';

class SignupView extends StatefulWidget {

   static route() => MaterialPageRoute(builder:(context) => const SignupView(),);

  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {

  final appbar = UiConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Center(
        child: SingleChildScrollView(
         child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              AuthField(
                controller: emailController,
                hintText: "Email",
                ),
              const SizedBox(
                height: 25,
                ),
              AuthField(
                controller: emailController,
                hintText: "Password",
                ),
              const SizedBox(
                height: 40,
                ),
              Align(
                alignment: Alignment.topRight,
                child: RoundedSmallButton(onTap: (){},
                 label: "Done",
                ),
              ),
              const SizedBox(
                height: 40,
                ),
                RichText(text: TextSpan(
                  text: "Already have an account?",
                  style: const TextStyle(
                    fontSize: 16
                  ),
                  children: [
                    TextSpan(
                      text: " Login",
                      style: const TextStyle(
                        color: Pallete.blueColor,
                        fontSize: 16
                      ),
                      recognizer: TapGestureRecognizer()..onTap =(){
                        Navigator.push(context, LoginView.route()
                        );
                      },
                    )
                  ]
                ))
            ],
          ),
         ),
        ),
      ),
    );
  }
}