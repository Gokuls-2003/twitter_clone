import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI:  ref.watch(authAPIProvider),
    userAPI:  ref.watch(userAPIProvider)
  );
});


// final currentUserDetailsProvider = FutureProvider<UserModel?>((ref) async {
//   final currentUser = await ref.watch(currentUserAccountProvider.future);
//   if (currentUser == null) {
//     return null;
//   }
//   final userDetails = await ref.watch(userDetailsProvider(currentUser.$id).future);
//   return userDetails;
// });


// //66715fb46a4c26d7adc
final currentUserDetailsProvider = FutureProvider((ref) {
    final currentUserId = ref.watch(currentUserAccountProvider).value!.$id; 
    print(currentUserId); 
    final userDetails = ref.watch(userDetailsProvider(currentUserId));
    return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid)  {
  final authController = ref.watch(authControllerProvider.notifier);
  print(authController.getUserData(uid));
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool>{
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
     required UserAPI userAPI 
     }) : _authAPI =authAPI,
          _userAPI = userAPI,
      super(false);
  // state = isLoading

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password
    );
    state=false;
    res.fold(
      (l) => ShowSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
           name: getNameFromEmail(email),
            followers: const  [],
            following: const [],
            profilePic: '',
            bannerPic: '',
            uid: r.$id,
            bio: '', 
            isTwitterBlue: false
            );
          final res2 = await  _userAPI.saveUserData(userModel);
          res2.fold((l) => ShowSnackBar(context, l.message), (r){
            ShowSnackBar(context, "Account created! Please Login.");
            Navigator.push(context, LoginView.route());
          }
        );
      }
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async{
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password
    );
    state=false;
    res.fold(
      (l) => ShowSnackBar(context, l.message),
      (r) {
         Navigator.push(context, HomeView.route());
      },
     );
  }


  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}