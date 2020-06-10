import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';

Widget solidButton(String text, Function onTap) {
  return Container(
    width: double.infinity,
    child: RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: onTap,
      // color: Color(0xff047bfe),
      color: softGreen,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(text, style: level2softw.copyWith(fontFamily: 'OS_bold')),
      ),
    ),
  );
}

Widget lightButton(String text, Function onTap) {
  return Container(
    width: double.infinity,
    child: OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: onTap,
      borderSide: BorderSide(style: BorderStyle.solid, color: Colors.black, width: 1.5),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(text, style: level1),
      ),
    ),
  );
}
