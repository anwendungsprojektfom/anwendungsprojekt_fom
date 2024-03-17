import 'package:flutter/material.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart'; // Importieren Sie die ProfileScreen-Klasse

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('This is our homescreen'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedIconTheme: const IconThemeData(color: Colors.blue),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        onTap: (int index) {
          if (index == 2) { // Überprüfen Sie, ob der "Profile" Tab ausgewählt wurde (Index 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()), // Navigieren Sie zur ProfileScreen
            );
          }
        },
      ),
    );
  }
}
