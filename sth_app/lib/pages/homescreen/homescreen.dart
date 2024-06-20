import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sth_app/pages/homescreen/postwidget.dart';
import 'package:sth_app/technical/technical.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logger.d('Building HomeScreen...');
    return Scaffold(
      appBar: CustomAppBar(
          title: Image.asset('assets/images/FinalLogoSTHOriginal.png', height: 80),
          onBack: false,
          showChatIcon: true,
          showSettings: false),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // First Post
            PostWidget(
              userId: 'JN2dcl4RbBNSs7VGEbYZ',
            ),
            // Second Post
            PostWidget(
              userId: 'JN2dcl4RbBNSs7VGEbYC',
            ),
            PostWidget(
              userId: 'JN2dcl4RbBNSs7VGEbYB',
            ),
            PostWidget(
              userId: 'JN2dcl4RbBNSs7VGEbYA',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }
}
