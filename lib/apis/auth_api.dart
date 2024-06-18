import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';

final authAPIProvider = Provider((ref){
  final account = ref.watch(appwriteAccountProvider);
     return AuthAPI(
      account: account,
      );
});


abstract class IAuthAPI {
  // want to signup, want to get user account -> Account
  // want to access user related data -> model.User
  FutureEither<model.User> signUp({   
    required String email,
    required String password,
  });

  FutureEither<model.Session> login({   
    required String email,
    required String password,
  });

    Future<model.User?> currentUserAccount();
}



class AuthAPI implements IAuthAPI{
  final Account _account;
  
  AuthAPI({required Account account}):  _account = account;

  @override
        Future<model.User?> currentUserAccount() async{
        try {
         return await _account.get();
        } on AppwriteException {
        return null;
       }
       catch (e) {
        return null;
       }
        }

  @override
    FutureEither<model.User> signUp({
      required String email,
      required String password,
    }) async{
      try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password
        );
        return right(account);
      } on AppwriteException catch(e, stackTrace){
        return left(
          Failure(e.message??'Some unexpected error occured', stackTrace));
      }
       catch (e, stackTrace) {
        return left(Failure(e.toString(), stackTrace));
      }
    }
    
      @override
      FutureEither<model.Session> login({
        required String email,
        required String password
        }) async {
          try {
           final session = await _account.createEmailPasswordSession(
            email: email,
            password: password
          );
          return right(session);
          } on AppwriteException catch (e, stackTrace){
            return left(
              Failure(e.message ??  'Some unexpected error occurred', stackTrace)
            );
          }
          catch (e, stackTrace) {
            return left(
              Failure(e.toString(), stackTrace)
            );
          }
      }
}