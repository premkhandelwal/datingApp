import 'package:dating_app/arguments/chat_screen_arguments.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
    );

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        final routeNames = route.split(",");
        final Map<int, String> splitRoutes = {
          for (int i = 0; i < routeNames.length; i++) i: routeNames[i]
        };
        Navigator.of(context).pushNamed(splitRoutes[0]!,
            arguments: ChatScreenArguments(splitRoutes[1]!, splitRoutes[2]!));
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("easy_approach",
              "easy_approach_channel", "This is our notification Channel",
              importance: Importance.max, priority: Priority.high),
          iOS: IOSNotificationDetails(
              presentAlert: true, presentBadge: true, presentSound: true));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
