import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getpass/Flash.dart';

class NotificationService {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitSetting= const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitSetting= DarwinInitializationSettings();
    var initializationSettings=InitializationSettings(
      android: androidInitSetting,
      iOS: iosInitSetting
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse:
        (payLoad){
          MessageHandler(context, message);
    });
  }

  void firebaseInitState(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;

      if (kDebugMode) {
        print("Notification title: ${notification?.title}");
        print("Notification body: ${notification?.body}");
      }

      if (notification != null && androidNotification != null) {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: "This channel is used for important notifications.",
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: "my_data",
    );
  }


  Future<void> NotificationHandler(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      MessageHandler(context, event);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        MessageHandler(context, message);
      }
    });
  }


  Future<void> MessageHandler(BuildContext context, RemoteMessage message) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder){
      return Flash();
    }));
}

  Future iosForegroundMessage() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
  }
}