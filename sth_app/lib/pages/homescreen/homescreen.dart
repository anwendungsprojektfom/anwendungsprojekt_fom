import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/FinalLogoSTHOriginal.png',
            height: 80), // Stellen Sie die Größe nach Bedarf ein
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              // Handle Chat Icon press
            },
          ),
        ],
      ),
      body: Center(
        child: Text('This is our homescreen'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }
}
