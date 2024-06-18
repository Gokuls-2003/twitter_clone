import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallate.dart';

class SignupView extends ConsumerStatefulWidget {

   static route() => MaterialPageRoute(builder:(context) => const SignupView(),);

  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {

  final appbar = UiConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  

  void onSignUp(){
    final res = ref.read(authControllerProvider.notifier)
      .signUp(
        email: emailController.text,
        password: passwordController.text,
        context: context
      );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading 
          ? const  Loader()
          : Center(
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
                      controller: passwordController,
                      hintText: "Password",
                      ),
                    const SizedBox(
                      height: 40,
                      ),
                    Align(
                      alignment: Alignment.topRight,
                      child: RoundedSmallButton(onTap: onSignUp,
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