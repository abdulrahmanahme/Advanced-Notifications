import 'package:flutter/material.dart';
import 'package:notifications/home_screen/home_screen.dart';
import 'package:notifications/notification/notification.dart';
var navigatorKey =GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
