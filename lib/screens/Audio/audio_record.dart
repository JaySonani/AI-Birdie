import 'dart:async';
import 'dart:io';
// import 'package:aibirdie/components/waves.dart';
import 'package:aibirdie/components/waves.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/components/buttons.dart';
import 'package:aibirdie/screens/Audio/audio_identify.dart';
import 'package:flutter_animation_set/widget/transition_animations.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
// import 'package:flutter_animation_set/widget/transition_animations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:timer_builder/timer_builder.dart';
// import 'package:timer_builder/timer_builder.dart';

class AudioRecord extends StatefulWidget {
  @override
  _AudioRecordState createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  FlutterAudioRecorder recorder;
  String filePath;
  File audioFile;

  int min = 0;
  int sec = 0;

  double timeLimit = 8.0;

  bool cancelTimer = false;

  @override
  void initState() {
    super.initState();
    startRecording();
    listenTimeLimit();
  }

  void listenTimeLimit() async {
    Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (cancelTimer) {
        timer.cancel();
      }
      if (timer.tick == timeLimit * 2) {
        timer.cancel();
        var result = await recorder.stop();
        audioFile = File(result.path);
        if (audioFile != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AudioIdentify(file: audioFile,)));
        }
      }
    });
  }

  Future startRecording() async {
    filePath =
        '/storage/emulated/0/AiBirdie/Audios/${DateTime.now().millisecondsSinceEpoch.toString()}.wav';
    recorder = FlutterAudioRecorder(
      filePath,
      audioFormat: AudioFormat.WAV,
      sampleRate: 44100,
    );

    await FlutterAudioRecorder.hasPermissions;

    await recorder.initialized;
    await recorder.start();
    // var recording = await recorder.current(channel: 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Hero(
                      tag: 'mic',
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            child: YYDoubleBounce(),
                            width: 100,
                            height: 100,
                          ),
                          Icon(
                            Icons.mic,
                            size: 50,
                            color: softGreen,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Recording...",
                      style: level2w,
                    ),
                    AnimatedWave(
                      barColor: Colors.white,
                    ),
                    myTimerWidget(),
                    Text(
                      "Recording limit: $timeLimit seconds",
                      style: level2softdp.copyWith(color: Colors.grey),
                    ),
                    solidButton("End Recording", () async {
                      setState(() {
                        cancelTimer = true;
                      });
                      var result = await recorder.stop();
                      audioFile = File(result.path);

                      if (audioFile != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AudioIdentify(file: audioFile,)));
                      }
                    }),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget myTimerWidget() {
    var mFiller, sFiller;
    return TimerBuilder.periodic(
      Duration(seconds: 1),
      builder: (context) {
        if (sec > 59) {
          sec = 0;
          min++;
        }
        sFiller = sec <= 9 ? "0" : "";
        mFiller = min <= 9 ? "0" : "";

        return Container(
          child: Text(
            "$mFiller$min:$sFiller${sec++}",
            style: level2softw.copyWith(fontSize: 50),
          ),
        );
      },
    );
  }

  Future<bool> _willPopCallback() async {
    Alert(
      type: AlertType.warning,
      content: Text(
        "Are you sure you want to discard your recording?",
        style: level2softdp,
        textAlign: TextAlign.center,
      ),
      style: AlertStyle(
        animationType: AnimationType.fromBottom,
      ),
      buttons: [
        DialogButton(
            radius: BorderRadius.circular(30),
            color: darkPurple,
            child: Text(
              "Discard",
              style: level2softdp.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              await recorder.stop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              await File(filePath).delete();
            }),
        DialogButton(
            radius: BorderRadius.circular(30),
            color: Colors.white,
            child: Text(
              "Cancel",
              style: level2softdp.copyWith(
                  color: softGreen, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
      context: context,
      title: "Recording in progress",
    ).show();

    return false;
  }
}
