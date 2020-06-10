import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';

Widget dismissedBackground() {
    return Container(
        // height: 100,
        // margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
    color: Colors.red,
    boxShadow: [
      BoxShadow(
        offset: Offset(-6.00, -6.00),
        color: Color(0xffffffff).withOpacity(0.80),
        blurRadius: 10,
      ),
      BoxShadow(
        offset: Offset(6.00, 6.00),
        color: Color(0xff000000).withOpacity(0.20),
        blurRadius: 10,
      ),
    ],
    borderRadius: BorderRadius.circular(15),
        ),
        child: Center(child: Text("Deleted", style: level2softw,),),
      );
  }