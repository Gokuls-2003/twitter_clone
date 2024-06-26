import 'dart:convert';

import 'package:twitter_clone/enum/notification_type_enum.dart';

class AppNotification {
  final String text;
  final String postId;
  final String id;
  final String uid;
  final NotificationType notificationType;
  AppNotification({
    required this.text,
    required this.postId,
    required this.id,
    required this.uid,
    required this.notificationType,
  });
  

  AppNotification copyWith({
    String? text,
    String? postId,
    String? id,
    String? uid,
    NotificationType? notificationType,
  }) {
    return AppNotification(
      text: text ?? this.text,
      postId: postId ?? this.postId,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'postId': postId,
      // 'id': id,
      'uid': uid,
      'notificationType': notificationType.type,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      text: map['text'] ?? '',
      postId: map['postId'] ?? '',
      id: map['\$id'] ?? '',
      uid: map['uid'] ?? '',
      notificationType: (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppNotification.fromJson(String source) => AppNotification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppNotification(text: $text, postId: $postId, id: $id, uid: $uid, notificationType: $notificationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppNotification &&
      other.text == text &&
      other.postId == postId &&
      other.id == id &&
      other.uid == uid &&
      other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      postId.hashCode ^
      id.hashCode ^
      uid.hashCode ^
      notificationType.hashCode;
  }
}
