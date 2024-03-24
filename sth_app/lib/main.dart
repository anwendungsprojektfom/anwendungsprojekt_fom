import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sth_app/pages/chatscreen/chatscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';
import 'package:sth_app/pages/searchscreen/searchscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SthApp());
}

class SthApp extends StatelessWidget {
  const SthApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'STH App', debugShowCheckedModeBanner: false, initialRoute: '/homescreen', routes: {
      '/homescreen': (context) => const HomeScreen(),
      '/chatscreen': (context) => const ChatScreen(),
      '/profilescreen': (context) => const ProfileScreen(),
      '/searchscreen': (context) => const SearchScreen(),
    });
  }
}
