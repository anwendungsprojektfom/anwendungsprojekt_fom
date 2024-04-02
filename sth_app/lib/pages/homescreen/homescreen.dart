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
    return const Scaffold(
      appBar: CustomAppBar(title: 'HomeScreen', onBack: null),
      body: Center(
        child: Text('This is our homescreen'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }
}
