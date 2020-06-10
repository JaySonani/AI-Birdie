import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:aibirdie/components/buttons.dart';
import 'package:aibirdie/screens/Audio/audio_result.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class AudioIdentify extends StatefulWidget {
final File file;

  AudioIdentify({this.file});
  @override
  _AudioIdentifyState createState() => _AudioIdentifyState();
}

class _AudioIdentifyState extends State<AudioIdentify> {
  bool isPlaying = false;
  // IconData playIcon = Icons.play_arrow;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          if (isPlaying == true) {
            await audioPlayer.stop();
            setState(() {
              isPlaying = false;
            });
          }
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          // if (file.path.substring(file.path.length - 5) == "e.wav") {
          //   Navigator.of(context).pop();
          //   print(file.path.substring(file.path.length - 5));
          // } else if (file.path.substring(file.path.length - 4) == ".wav") {
          //   Navigator.of(context).pop();
          //   Navigator.of(context).pop();
          // }

/**original */
          // if (file.path.substring(file.path.length - 4) == ".wav") {
          //   Navigator.of(context).pop();
          //   Navigator.of(context).pop();
          // }

          return new Future(() => true);
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'images/bb.png',
                  width: double.infinity,
                ),
                Text(
                  "Recording saved",
                  style: level2softdp.copyWith(fontSize: 25),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () async {
                          if (isPlaying == true) {
                            await audioPlayer.stop();
                            setState(() => isPlaying = false);
                          } else {
                            await audioPlayer.play(widget.file.path, isLocal: true);
                            setState(() => isPlaying = true);
                            audioPlayer.onPlayerCompletion.listen(
                                (event) => setState(() => isPlaying = false));
                          }
                        },
                        borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            width: 1.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // TikTikTimer(
                            //     backgroundColor: Colors.white,
                            //     timerTextStyle:
                            //         level2softdp.copyWith(fontSize: 20),
                            //     height: 50,
                            //     width: 100,
                            //     running: isPlaying,
                            //     initialDate: DateTime.now()),
                            Text(
                              "Click to listen",
                              style: level2softdp,
                            ),
                            Icon(
                              isPlaying == true ? Icons.stop : Icons.play_arrow,
                              size: 40,
                              color:
                                  isPlaying == true ? Colors.red[900] : softGreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    solidButton("Identify", () async {
                      await audioPlayer.stop();
                      setState(() {
                        isPlaying = false;
                      });

                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        Alert(
                            context: context,
                            title: "Network Error",
                            type: AlertType.error,
                            desc:
                                "Your phone is not connected to the internet.\nCheck your connection and try again",
                            style: AlertStyle(
                              descStyle: level2softdp,
                              isCloseButton: false,
                              titleStyle: level2softdp.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
                            
                            ),
                            buttons: [
                              DialogButton(
                                radius: BorderRadius.circular(100),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: softGreen,
                                child: Text(
                                  "OK",
                                  style: level2softw,
                                ),
                              ),
                            ]).show();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioResult(widget.file),
                          ),
                        );
                      }
                    })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
