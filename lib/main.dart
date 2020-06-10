import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/landing_page.dart';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await [
    Permission.storage,
    Permission.camera,
    Permission.microphone,
  ].request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Birdie',
      theme: ThemeData(primaryColor: darkPurple),
      home: LandingPage(cameras),
      debugShowCheckedModeBanner: false,
    );
  }
}
