  import 'package:flutter/material.dart';

  myTransition(BuildContext context, double a, double b, var myPage) {
    return Navigator.push(
      context,
      PageRouteBuilder(transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secAnimation,
          Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(a, b),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }, pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secAnimation) {
        return myPage;
      }),
    );
  }