import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sth_app/pages/homescreen/postwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger _logger = Logger();
  final int _currentPage = 0; // Variable for the slider value

  @override
  Widget build(BuildContext context) {
    _logger.d('Building HomeScreen...');
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/FinalLogoSTHOriginal.png', height: 80),
        automaticallyImplyLeading: false, // Hide the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              // Action when the chat button is clicked
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // First Post
            PostWidget(
              userId: 'JN2dcl4RbBNSs7VGEbYZ',
            ),
            // Second Post
            PostWidget(
              userId: 'JN2dcl4RbBNSs7VGEbYZ',
            ),
          ],
        ),
      ),
    );
  }
}
