import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Color myBlue = Color(0xff047bfe);
final Color darkPurple = Color(0xff1D1B27);
final Color softGreen = Color(0xff1CAA53);

final Color inActive = Color(0xff666666);

final TextStyle heading1 = TextStyle(
  fontSize: 30,
  // fontFamily: 'M_semi_bold'
);
final TextStyle level1 = TextStyle(
  color: Colors.black,

  fontSize: 15,
  // fontFamily: 'M_medium'
);
final TextStyle level1w =
    TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'OS_regular');

final TextStyle level2 = TextStyle(
    fontSize: 25,
    // fontFamily: 'M_medium',
    color: Colors.black);

final TextStyle level2g = TextStyle(
    fontSize: 25,
    // fontFamily: 'M_medium',
    color: softGreen);
final TextStyle level1dp =
    TextStyle(fontSize: 15, fontFamily: 'OS_regular', color: darkPurple);

final TextStyle level2w =
    TextStyle(fontSize: 25, color: Colors.white, fontFamily: 'OS_regular');
final TextStyle level2softg =
    TextStyle(fontSize: 25, color: softGreen, fontFamily: 'OS_regular');

final TextStyle level2softdp =
    TextStyle(fontSize: 15, fontFamily: 'OS_regular', color: darkPurple);

final TextStyle level2softw =
    TextStyle(fontSize: 15, fontFamily: 'OS_regular', color: Colors.white);

bool signedIn = false;
String globalUserID = '';
Future<void> setSignInStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  signedIn =  prefs.getBool('SignInStatus');
  globalUserID = prefs.getString('userID');
}
