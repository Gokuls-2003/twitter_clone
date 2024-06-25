import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';

import '../models/user_model.dart';


final userAPIProvider = Provider((ref){
  final user = ref.watch(appwriteDatabasesProvider);
   return UserAPI(
    db: user,
    realTime: ref.watch(appwriteRealtimeProvider)
    );
});

abstract class IUserAPI{
  FutureEitherVoid saveUserData(UserModel UserModel);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(UserModel user);
  FutureEitherVoid addToFollowing(UserModel user);
}

class UserAPI implements IUserAPI{
  final Databases _db;
  final Realtime _realTime;
  UserAPI({required Databases db, required Realtime realTime}) : _db = db, _realTime = realTime;
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
       await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userscollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    }on AppwriteException catch(e, st){
      return left(
        Failure(
          e.message?? 'Some unexpected error occur ', st
          )
        );
      }catch (e, st) {
        return left(
          Failure(e.toString(), st)
        );
      
    }
  }
  
  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userscollection,
      documentId: uid
      );
  }
  
  @override
  Future<List<model.Document>> searchUserByName(String name) async { 
     final documents= await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userscollection,
      queries: [
        Query.search('name', name)
      ]
      );
    return documents.documents;
  }
  
  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {

    try {
       await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userscollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    }on AppwriteException catch(e, st){
      return left(
        Failure(
          e.message?? 'Some unexpected error occur ', st
          )
        );
      }catch (e, st) {
        return left(
          Failure(e.toString(), st)
        );
    }
  }
  
  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realTime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.userscollection}.documents'
    ]).stream;
  }
  
  @override
  FutureEitherVoid followUser(UserModel user) async {
    try {
       await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userscollection,
        documentId: user.uid,
        data: {
          "followers" : user.followers
        }
      );
      return right(null);
    }on AppwriteException catch(e, st){
      return left(
        Failure(
          e.message?? 'Some unexpected error occur ', st
          )
        );
      }catch (e, st) {
        return left(
          Failure(e.toString(), st)
        );
    }
  }
  
  @override
  FutureEitherVoid addToFollowing(UserModel user) async {
     try {
       await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userscollection,
        documentId: user.uid,
        data: {
          "following" : user.following
        }
      );
      return right(null);
    }on AppwriteException catch(e, st){
      return left(
        Failure(
          e.message?? 'Some unexpected error occur ', st
          )
        );
      }catch (e, st) {
        return left(
          Failure(e.toString(), st)
        );
    }
  }
}