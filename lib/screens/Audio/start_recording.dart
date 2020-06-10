import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/Audio/audio_record.dart';
import 'package:aibirdie/screens/landing_page.dart';
import 'package:flutter/material.dart';

class StartRecording extends StatefulWidget {
  @override
  _StartRecordingState createState() => _StartRecordingState();
}

class _StartRecordingState extends State<StartRecording> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            LandingPage.controller.animateToPage(1,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          color: darkPurple,
        ),
        backgroundColor: Color(0xfffafafa),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Record a bird",
          style: level2softdp.copyWith(fontSize: 20),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                  tag: 'mic',
                  child: Container(
                    height: 150,
                    width: 150,
                    child: RaisedButton(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      color: softGreen,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => AudioRecord()),
                        );
                      },
                      child: Icon(
                        Icons.mic,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Tap to record",
                  style: level2softdp.copyWith(
                    fontSize: 25,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
