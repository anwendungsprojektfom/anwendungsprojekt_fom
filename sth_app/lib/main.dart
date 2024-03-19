import 'package:flutter/material.dart';
import 'package:sth_app/pages/chatscreen/chatscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';

void main() {
  runApp(const SthApp());
}

class SthApp extends StatelessWidget {
  const SthApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'STH App', debugShowCheckedModeBanner: false, initialRoute: '/homescreen', routes: {
      '/homescreen': (context) => const HomeScreen(),
      '/chatscreen': (context) => const ChatScreen(),
    });
  }
}
