import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/notification_model.dart'; 

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(db: ref.watch(appwriteDatabasesProvider),
         realtime: ref.watch(appwriteRealtimeProvider)
  );
});


abstract class INotificationAPI {
  FutureEitherVoid createNotification(AppNotification notification);
  Future<List<Document>> getNotifications(String uid); 
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;

  NotificationAPI({required Databases db, required Realtime realtime}) : _db = db, _realtime = realtime;

  @override
  FutureEitherVoid createNotification(AppNotification notification) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.notificationCollection,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', st),
      );
    } catch (e, st) {
      return left(
        Failure(e.toString(), st),
      );
    }
  }
    @override
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
       collectionId: AppWriteConstants.notificationCollection,
       queries: [
        Query.equal('uid', uid)
       ]
    );
    return documents.documents;
  }

   @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.notificationCollection}.documents'
    ]).stream;
  }
  
}
