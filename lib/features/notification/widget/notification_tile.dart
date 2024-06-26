import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/enum/notification_type_enum.dart';
import 'package:twitter_clone/models/notification_model.dart' as model;
import 'package:twitter_clone/theme/pallate.dart';

class NotificationTile extends StatelessWidget {
  final model.AppNotification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow 
      ? const Icon(
        Icons.person,
        color: Pallete.blueColor,) 
        : notification.notificationType ==NotificationType.like ? SvgPicture.asset(
          AssetsConstants.likeFilledIcon,
          color: Pallete.redColor,  
          height: 20,
        )
         : notification.notificationType == NotificationType.retweet ? SvgPicture.asset(
          AssetsConstants.retweetIcon,
          color: Pallete.whiteColor,
          height: 20,
        ) : null,
        title: Text(notification.text),
    );
  }
}
