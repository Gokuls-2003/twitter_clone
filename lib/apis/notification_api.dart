import 'package:appwrite/appwrite.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/notification_model.dart'; 

abstract class INotificationAPI {
  FutureEitherVoid createNotification(AppNotification notification);
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;

  NotificationAPI({required Databases db}) : _db = db;

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
}
