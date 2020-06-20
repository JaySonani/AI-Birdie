import 'dart:io';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/Audio/start_recording.dart';
import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/screens/dashboard.dart';
import 'package:aibirdie/screens/Image/camera_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras;

class LandingPage extends StatefulWidget {
  static PageController controller = PageController(
    initialPage: 1,
    keepPage: false,
  );

  static PageController camController = PageController(
    keepPage: false,
  );

  LandingPage(List<CameraDescription> icameras) {
    cameras = icameras;
  }
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int camIndex = 0;
  var _currentPage = 1;
  var _pages = [
    DashBoard(),
    CameraScreen(cameras),
    StartRecording(),
  ];

  @override
  void initState() {
    super.initState();
    createDirectories();
    checkSignInStatus();
  }

  void checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("Initial Sign in status: ${prefs.getBool('SignInStatus')}");
    prefs.getBool('SignInStatus') ?? await prefs.setBool('SignInStatus', false);
    setSignInStatus();
  }

  void createDirectories() async {
    Directory aibirdie = Directory('/storage/emulated/0/AiBirdie');
    Directory imageDir = Directory('/storage/emulated/0/AiBirdie/Images');
    Directory audioDir = Directory('/storage/emulated/0/AiBirdie/Audios');
    // Directory notesDir = Directory('/storage/emulated/0/AiBirdie/Notes');
    // File imageMetaData =
    //     File('/storage/emulated/0/AiBirdie/image_metadata.json');
    // File checkFile = File('/storage/emulated/0/AiBirdie/Notes/checklist.txt');
    if (!await aibirdie.exists()) await aibirdie.create();
    if (!await imageDir.exists()) await imageDir.create();
    if (!await audioDir.exists()) await audioDir.create();
    // if (!await notesDir.exists()) await notesDir.create();
    // if (!await imageMetaData.exists()) await imageMetaData.writeAsString('');
    // if (!await checkFile.exists()) await checkFile.writeAsString('');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: PageView.builder(
          dragStartBehavior: DragStartBehavior.down,
          controller: LandingPage.controller,
          itemCount: _pages.length,
          itemBuilder: (BuildContext context, int index) {
            return _pages[index];
          },
          onPageChanged: ((index) => setState(() => _currentPage = index)),
        ),
      ),
      // return new Future(() => exitApp);
    );
  }

  Future<bool> _willPopCallback() async {
    if (_currentPage == 1) {
      // if (LandingPage.camController.page == 1) {
      //   LandingPage.camController.animateToPage(0,
      //       duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      // } else
      return true;
    } else
      LandingPage.controller.animateToPage(1,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);

    return false;
  }
}
