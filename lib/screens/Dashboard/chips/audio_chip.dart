import 'dart:io';
import 'dart:math';
// import 'package:flutter_animation_set/widget/transition_animations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:aibirdie/components/dimissed_background.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioChip extends StatefulWidget {
  @override
  _AudioChipState createState() => _AudioChipState();
}

class _AudioChipState extends State<AudioChip>
    with SingleTickerProviderStateMixin {
  var audios = [];
  AudioPlayer audioPlayer = AudioPlayer();
  var isPlaying = [];
  var seekPosition = 0.0;
  var audioDuration = 10.0;
  AnimationController rotationController;
  final random = Random();
  @override
  void initState() {
    readAudios();
    rotationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    rotationController.dispose();
    super.dispose();
  }

  Future<void> readAudios() async {
    Directory audDir = Directory('/storage/emulated/0/AiBirdie/Audios');
    var temp = audDir.list();
    audios = await temp.toList();
    setState(() {
      for (var i = 0; i < audios.length; i++) isPlaying.add(false);
    });
  }

  void deleteAudio(index) {
    File f = audios[index];
    f.delete();
    readAudios();
  }

  @override
  Widget build(BuildContext context) {
    return audios.length == 0
        ? noRecordingWidget(context)
        : Container(
            height: audios.length <= 5
                ? (audios.length * 200).toDouble()
                : (audios.length * 130).toDouble(),
            child: ListView.builder(
              // shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: audios.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 300),
                  child: ScaleAnimation(
                    scale: 1.5,
                    child: FadeInAnimation(
                      child: AnimatedContainer(
                        padding: EdgeInsets.symmetric(
                          vertical: isPlaying[index] == true ? 20 : 0,
                        ),
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: isPlaying[index] == true
                              ? Color(0xff1c1c1e)
                              // Color(0xff242424)
                              : Color(0xfff5f5f5),
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
                        child: Dismissible(
                          background: dismissedBackground(),
                          key: Key(audios[index].path),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (dismissDirection) {
                            deleteAudio(index);
                            if (isPlaying[index] == true) {
                              audioPlayer.stop();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Row(
                              //   children: <Widget>[
                              isPlaying[index]
                                  ? RotationTransition(
                                      turns: Tween(begin: 0.0, end: 1.0)
                                          .animate(rotationController),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: 75,
                                        width: 75,
                                        child: RaisedButton(
                                          elevation: 5.0,
                                          color: Color(0xffff2c55),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          onPressed: () {
                                            rotationController.stop();
                                            playAudio(index);
                                          },
                                          child: Icon(
                                            Icons.music_note,
                                            // FontAwesomeIcons.stop,
                                            // size: 30,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(10),
                                      height: 75,
                                      width: 75,
                                      child: RaisedButton(
                                        elevation: 5.0,
                                        color: softGreen,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        onPressed: () {
                                          rotationController.repeat();
                                          playAudio(index);
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.play,

                                          // Icons.music_note,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      titleWidget(audios[index], index),
                                      Slider(
                                        activeColor: isPlaying[index]
                                            ? Color(0xffff2c55)
                                            : Colors.black38,
                                        inactiveColor: Color(0xffe7e6eb),
                                        value:
                                            isPlaying[index] ? seekPosition : 0,
                                        min: 0,
                                        max: audioDuration,
                                        onChanged: ((value) {
                                          if (isPlaying[index])
                                            setState(
                                                () => seekPosition = value);
                                        }),
                                        onChangeEnd: (value) {
                                          if (isPlaying[index]) {
                                            audioPlayer.seek(Duration(
                                                seconds: value.toInt()));
                                          }
                                        },
                                      ),
                                      isPlaying[index]
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  dancingBars(),
                                                  TimerBuilder.periodic(
                                                    Duration(seconds: 1),
                                                    builder: ((context) => Text(
                                                          getTimeStamp(),
                                                          style: level2softw,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              //   ],
                              // ),

                              IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteAudio(index);
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget dancingBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (var i = 0; i < 3; i++)
          AnimatedContainer(
            margin: EdgeInsets.only(right: 3),
            duration: Duration(milliseconds: 300),
            height: randomInt(0, 20).toDouble(),
            width: 4.0,
            color: Colors.white,
          ),
      ],
    );
  }

  String getTimeStamp() {
    var sec = seekPosition.toInt() % 60;
    var min = seekPosition.toInt() ~/ 60;
    var mFiller = min <= 9 ? 0 : '';
    var sFiller = sec <= 9 ? 0 : '';
    return "$mFiller$min:$sFiller$sec";
  }

  void playAudio(int index) {
    //This is very complicated method, do not even try to understand it..
    //Even if I look back at this after a while, I won't get it 😂😂😂

    if (isPlaying.indexOf(true) != -1 && isPlaying[index] == false) {
      audioPlayer.stop();
      setState(() => isPlaying[isPlaying.indexOf(true)] = false);
      File f = audios[index];
      audioPlayer.play(f.path, isLocal: true);
      setState(() => isPlaying[index] = true);
      audioPlayer.onPlayerCompletion
          .listen((event) => setState(() => isPlaying[index] = false));
      return;
    }

    if (isPlaying[index] == true) {
      audioPlayer.stop();
      setState(() => isPlaying[index] = false);
    } else {
      setState(() => isPlaying[index] = true);
      audioPlayer.onAudioPositionChanged.listen((a) =>
          setState(() => seekPosition = a.inMicroseconds.toDouble() / 1000000));
      File f = audios[index];
      audioPlayer.play(f.path, isLocal: true);

      audioPlayer.onDurationChanged.listen((event) => setState(
          () => audioDuration = event.inMicroseconds.toDouble() / 1000000));

      // audioPlayer.durationHandler = (duration) => setState((){
      //   print(duration.inSeconds);

      // audioDuration = duration.inMicroseconds.toDouble() / 1000000;

      // });

    }
    audioPlayer.onPlayerCompletion
        .listen((event) => setState(() => isPlaying[index] = false));
  }

  Widget noRecordingWidget(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
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
          borderRadius: BorderRadius.circular(15.00),
        ),
        height: MediaQuery.of(context).size.height * 0.3,
        // color: Colors.red,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.library_music,
              size: 40,
              color: softGreen,
            ),
            Column(
              children: <Widget>[
                Text(
                  "No recordings to show.",
                  style: level2softdp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Click on",
                      style: level2softdp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Icon(
                        Icons.music_note,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                    Text(
                      "on the camera screen.",
                      style: level2softdp,
                    ),
                  ],
                ),
              ],
            ),
          ],
        )));
  }

  Widget titleWidget(File f, int index) {
    return Text(
      DateFormat("dd MMM, yyyy").format(f.lastModifiedSync()) +
          " " +
          DateFormat("H:mm").format(f.lastModifiedSync()),
      style: isPlaying[index] == true ? level2softw : level2softdp,
    );
  }

  int randomInt(int min, int max) => min + random.nextInt(max - min);
}
