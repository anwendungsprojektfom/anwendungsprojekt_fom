import 'package:flutter/material.dart';

class CustomPageRoute {
  static Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  static Route generateRoute(Widget page) {
    return _createRoute(page);
  }
}
