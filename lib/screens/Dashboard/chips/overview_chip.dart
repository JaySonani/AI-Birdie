// import 'dart:io';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_animation_set/widget/transition_animations.dart';

class OverviewChip extends StatefulWidget {
  @override
  _OverviewChipState createState() => _OverviewChipState();
}

class _OverviewChipState extends State<OverviewChip> {
  int imagesCaptured = 0;
  int audioRecorded = 0;
  int notesSaved = 0;
  int checkListCount = 0;
  SharedPreferences prefs;
  bool loading = false;
  bool internetCheck = true;

  @override
  void initState() {
    super.initState();
    setAllCount();
  }

  Future<void> setAllCount() async {
    Directory imgDir = Directory('/storage/emulated/0/AiBirdie/Images');
    Directory audDir = Directory('/storage/emulated/0/AiBirdie/Audios');
    // File noteFile = File('/storage/emulated/0/AiBirdie/Notes/notes.txt');
    // File checkListFile = File('/storage/emulated/0/AiBirdie/Notes/checklist.txt');

    var temp = imgDir.list();
    var temp2 = audDir.list();

    var images = await temp.toList();
    var audios = await temp2.toList();
    // var allNotes = await noteFile.readAsLines();
    // var checkList = await checkListFile.readAsLines();

    setState(() {
      imagesCaptured = images.length;
      audioRecorded = audios.length;
      //   notesSaved = allNotes.length;
      //   checkListCount = checkList.length;
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internetCheck = false;
      });
    } else {
      if (signedIn) {
        setState(() {
          loading = true;
        });

        prefs = await SharedPreferences.getInstance();
        Firestore.instance
            .collection('users')
            .document('${prefs.getString('userID')}')
            .get()
            .then((value) {
          List temp = value.data['userNotes'];
          setState(() {
            notesSaved = temp.length;
            loading = false;
          });
        });

        var checkDoc = await Firestore.instance
            .collection('users')
            .document('${prefs.getString('userID')}')
            .collection('userChecklists')
            .getDocuments();

        setState(() {
          checkListCount = checkDoc.documents.length - 1;
          internetCheck = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 150.00,
                // width: 100.00,
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
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Images",
                            style: level2softdp.copyWith(fontSize: 20),
                          ),
                          Text(
                            "Captured",
                            style: level2softdp.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                      Text(
                        "$imagesCaptured",
                        style: level2softg.copyWith(
                            fontSize: 40, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 150.00,
                // width: 100.00,
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
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Audio",
                            style: level2softdp.copyWith(fontSize: 20),
                          ),
                          Text(
                            "Recorded",
                            style: level2softdp.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                      Text(
                        "$audioRecorded",
                        style: level2softg.copyWith(
                            fontSize: 40, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        // Container(
        //   height: 150.00,
        //   // width: 315.00,
        //   decoration: BoxDecoration(
        //     color: Color(0xfff5f5f5),
        //     boxShadow: [
        //       BoxShadow(
        //         offset: Offset(-6.00, -6.00),
        //         color: Color(0xffffffff).withOpacity(0.80),
        //         blurRadius: 10,
        //       ),
        //       BoxShadow(
        //         offset: Offset(6.00, 6.00),
        //         color: Color(0xff000000).withOpacity(0.20),
        //         blurRadius: 10,
        //       ),
        //     ],
        //     borderRadius: BorderRadius.circular(15.00),
        //   ),
        //   child: Padding(
        //     padding: EdgeInsets.all(20.0),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             Text(
        //               "Accuracy",
        //               style: level2softdp.copyWith(fontSize: 20),
        //             ),
        //             Text(
        //               "Level",
        //               style: level2softdp.copyWith(fontSize: 20),
        //             ),
        //           ],
        //         ),
        //         Text(
        //           "84%",
        //           style: level2softg.copyWith(
        //               fontSize: 40, fontWeight: FontWeight.w900),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 20,
        // ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 150.00,
                // width: 100.00,
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
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Notes",
                            style: level2softdp.copyWith(fontSize: 20),
                          ),
                          Text(
                            "Saved",
                            style: level2softdp.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                      internetCheck
                          ? loading
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        softGreen),
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  signedIn ? "$notesSaved" : "0",
                                  style: level2softg.copyWith(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900),
                                )
                          : Container(
                              child: Icon(
                                Icons.error_outline,
                                color: softGreen,
                                size: 30,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 150.00,
                // width: 100.00,
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
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Checklist",
                            style: level2softdp.copyWith(fontSize: 20),
                          ),
                          Text(
                            "Birds",
                            style: level2softdp.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                      internetCheck
                          ? loading
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        softGreen),
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  signedIn ? "$checkListCount" : "0",
                                  style: level2softg.copyWith(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900),
                                )
                          : Container(
                              child: Icon(
                                Icons.error_outline,
                                color: softGreen,
                                size: 30,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
