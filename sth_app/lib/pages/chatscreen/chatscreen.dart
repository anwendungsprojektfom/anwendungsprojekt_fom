import 'package:flutter/material.dart';

class chatScreen extends StatefulWidget {
  const chatScreen({Key? key}) : super(key: key);

  @override
  _chatScreenState createState() => _chatScreenState();
}


class _chatScreenState extends State<chatScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STH App'),
        actions: <Widget> [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline), 
            onPressed: (){
              Navigator.pushNamed(context, '/chatScreen');
              },
            )
        ],
      ),
      body: const Center(
        child: Text("Chat Screen"),
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
      ),
    );
  }
}