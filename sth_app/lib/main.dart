import 'package:flutter/material.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';

void main() {
  runApp(const SthApp());
}

class SthApp extends StatelessWidget {
  const SthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      initialRoute: '/homescreen',
      //routes
      routes: {
        '/homescreen': (context) => const HomeScreen(),
        '/profilescreen': (context) => const ProfileScreen(),//Load profileScreen
      },
    );
  }
}
