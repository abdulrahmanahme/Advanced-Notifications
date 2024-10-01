import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notifications/main.dart';

class NotificationHelper {
  static String? firebaseUserToken;
  static init() async {
    await Firebase.initializeApp();
    await permissionNotifications();

    /// Get Firebase User Token
    firebaseUserToken = await FirebaseMessaging.instance.getToken();
    log('dd  ${firebaseUserToken}');

    /// Called when app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      log('Received a message in the foreground: ${remoteMessage.notification?.title}');
      final snackBar = SnackBar(
        content: Text('${remoteMessage.notification?.title}'),
        action: SnackBarAction(
          label: '${remoteMessage.notification?.body}',
          onPressed: () {
            print('Undo action pressed');
          },
        ),
      );
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
    });

    /// Called when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      log('Received a message in the background: ${remoteMessage.notification?.title}');
      log('Received a message in the body: ${remoteMessage.notification?.body}');
      final snackBar = SnackBar(
        content: Text('${remoteMessage.notification?.title}'),
        action: SnackBarAction(
          label: '${remoteMessage.notification?.body}',
          onPressed: () {
            // Code to execute when "Undo" is pressed
            print('Undo action pressed');
          },
        ),
      );
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
    });

    /// Called when the app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  static void _handleMessage(RemoteMessage remoteMessage) {
    log('Received a message in the background: ${remoteMessage.notification?.title}');
    log('Received a message in the body: ${remoteMessage.notification?.body}');
    final snackBar = SnackBar(
        content: Text('${remoteMessage.notification?.title}'),
        action: SnackBarAction(
          label: '${remoteMessage.notification?.body}',
          onPressed: () {
            // Code to execute when "Undo" is pressed
            print('Undo action pressed');
          },
        ),
      );
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
  }

  // /// Local Notification in Foreground

  // AndroidNotificationChannel channel = const AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   description:
  //       'This channel is used for important notifications.',
  //       // description

  //   importance: Importance.max,
  // );

  // void handleLocalNotificationInForeground(RemoteMessage message) async {
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);

  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;

  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           channelDescription: channel.description,
  //           icon: android.smallIcon,
  //   //         styleInformation:  BigPictureStyleInformation(
  //   //   bigPicture,
  //   //   largeIcon: largeIcon,
  //   // )
  //           // other properties...
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Future<Uint8List> _getByteArrayFromUrl(String url) async {
  //   final http.Response response = await http.get(Uri.parse(url));
  //   return response.bodyBytes;
  // }

  // final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
  //     await _getByteArrayFromUrl(notification.android!.imageUrl!));
  // final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
  //     await _getByteArrayFromUrl(notification.android!.imageUrl!));
  // final BigPictureStyleInformation bigPictureStyleInformation =
  //     BigPictureStyleInformation(
  //   bigPicture,
  //   largeIcon: largeIcon,
  // );
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
