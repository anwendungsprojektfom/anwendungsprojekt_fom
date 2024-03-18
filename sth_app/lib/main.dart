import 'package:flutter/material.dart';
import 'package:sth_app/pages/chatscreen/chatscreen.dart';

void main() {
  runApp(const STH_App());
}

class STH_App extends StatelessWidget {
  const STH_App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STH App', 
      debugShowCheckedModeBanner: false,
      initialRoute: '/chatScreen', routes: {
      '/chatScreen': (context) => const chatScreen(),
      }
    );
  }
}
