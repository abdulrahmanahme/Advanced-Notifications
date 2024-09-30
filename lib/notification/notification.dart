import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static String? firebaseUserToken;
  static init() async {
    await Firebase.initializeApp();
    await permissionNotifications();
    /// Get Firebase User Token
    firebaseUserToken = await FirebaseMessaging.instance.getToken();

    /// Called when app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {});

    /// Called when app in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    /// Called when the app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  static void _handleMessage(RemoteMessage remoteMessage) {}

  /// Local Notification in Foreground

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  void handleLocalNotificationInForeground() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);




  }

  /// Notification permission
  static Future permissionNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      // AppSettings.openAppSettings();
      log('User declined or has not accepted permission');
    }
  }

}
