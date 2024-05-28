import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/homescreen');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/searchscreen');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/profilescreen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTabIcon(Icons.home, 0, context),
          _buildTabIcon(Icons.search, 1, context),
          _buildTabIcon(Icons.person, 2, context),
        ],
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, int index, BuildContext context) {
    return GestureDetector(
      onTap: () => _onTabTapped(context, index),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: currentIndex == index ? Colors.blue : Colors.transparent, // Apply border when tab is selected
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: currentIndex == index ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
