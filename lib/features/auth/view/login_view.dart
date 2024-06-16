import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/common/rounded_small_button.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallate.dart';

class LoginView extends StatefulWidget {
  
  static route() => MaterialPageRoute(builder:(context) => const LoginView(),);

  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
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
                  text: "Don't have an account?",
                  style: const TextStyle(
                    fontSize: 16
                  ),
                  children: [
                    TextSpan(
                      text: " Sign up",
                      style: const TextStyle(
                        color: Pallete.blueColor,
                        fontSize: 16
                      ),
                      recognizer: TapGestureRecognizer()..onTap =(){
                        Navigator.push(context, SignupView.route(),
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
