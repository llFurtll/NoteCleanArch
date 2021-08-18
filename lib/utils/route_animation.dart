import 'package:flutter/material.dart';

Route createRoute(Widget tela) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => tela,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      final tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.ease
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    }
  );
}