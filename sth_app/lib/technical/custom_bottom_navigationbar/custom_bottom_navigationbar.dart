import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
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
      onTap: (int index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(
            context,
            '/homescreen',
          );
        }
        if (index == 1) {
          Navigator.pushReplacementNamed(
            context,
            '/searchscreen',
          );
        }
        if (index == 2) {
          Navigator.pushReplacementNamed(
            context,
            '/profilescreen',
          );
        }
      },
      selectedIconTheme: const IconThemeData(color: Colors.blue),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
    );
  }
}
