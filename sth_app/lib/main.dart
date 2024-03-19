import 'package:flutter/material.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';

void main() {
  runApp(const SthApp());
}

class SthApp extends StatelessWidget {
  const SthApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      // Define initial route
      initialRoute: '/homescreen',
      // Define routes
      routes: {
        '/homescreen': (context) => const HomeScreen(),
        // Add more routes as needed
        // Example:
        // '/secondPage': (context) => SecondPage(),
      },
    );
  }
}
