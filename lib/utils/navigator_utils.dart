import 'package:flutter/material.dart';

class NavigatorUtils {
  static pushTransparentPage(BuildContext context, Widget targetPage,
      {bool hasAnimation = true, bool present = false}) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => targetPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = present ? Offset(0.0, 0.02) : Offset(0.0, 0.02);
        if (!hasAnimation) {
          begin = Offset(0.0, 0.0);
        }
        const end = Offset(0.0, 0.0);
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
  }
}
