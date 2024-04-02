import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sth_app/pages/chatscreen/chatscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';
import 'package:sth_app/pages/searchscreen/searchscreen.dart';
import 'package:sth_app/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
