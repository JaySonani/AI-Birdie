import 'dart:io';
import 'package:aibirdie/components/not_signedIn_widget.dart';
import 'package:aibirdie/screens/Dashboard/checklist_birds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:aibirdie/components/dimissed_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  final checklistFile =
      File('/storage/emulated/0/AiBirdie/Notes/checklist.txt');

  // var isChecked = [];
  var checkList = [];

  var noCheckList = true;
  bool loading = true;
  bool birdLoading = true;
  String myUserID;

  String birdInput = '';
  QuerySnapshot snapShots;
  SharedPreferences prefs;

  @override
  void initState() {
    if (signedIn) {
      fetchData();
    }
    super.initState();
  }

  void fetchData() async {
    prefs = await SharedPreferences.getInstance();

    snapShots = await Firestore.instance
        .collection('users')
        .document('${prefs.getString('userID')}')
        .collection('userChecklists')
        .getDocuments();
    setState(() {
      for (var i in snapShots.documents) {
        if (i.documentID == "INIT") continue;
        checkList.add(i.documentID);
      }
 
      // print("cccc: $checkList");
    });
    // checkList = value.data['userChecklists'];

    if (checkList.length > 0)
      setState(() {
        noCheckList = false;
      });

    setState(() {
      loading = false;
    });
  }

  // void readChecklistFile() async {
  //   var value = await readContentsByLine(checklistFile);
  //   setState(() {
  //     if (value.length == 0) {
  //       noCheckList = true;
  //     } else {
  //       checkList = value;
  //       noCheckList = false;
  //     }
  //     // for (var i = 0; i < checkList.length; i++) isChecked.add(false);
  //   });
  // }

  Widget noNotesWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
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
              Icons.playlist_add_check,
              size: 40,
              color: softGreen,
            ),
            Column(
              children: <Widget>[
                Text(
                  "You have watched all the birds you added.",
                  style: level2softdp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  signedIn ? "Add new checklist" : "Save your checklists",
                  style: TextStyle(fontSize: 25, fontFamily: 'OS_semi_bold'),
                ),
                Text("Which birds would you like to see?", style: level2softdp),
              ],
            ),
            Visibility(
              visible: signedIn,
              child: FloatingActionButton(
                  backgroundColor: softGreen,
                  child: Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    Alert(
                      title: 'Name your checklist',
                      type: AlertType.none,
                      context: context,
                      style: AlertStyle(
                        titleStyle: level2softdp.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      content: Column(
                        children: <Widget>[
                          Icon(
                            Icons.playlist_add_check,
                            size: 40,
                            color: softGreen,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'E.g. Mandi trip',
                                hintStyle: TextStyle(fontFamily: 'OS_regular')),
                            style: level2softdp,
                            onChanged: (newText) {
                              setState(() {
                                birdInput = newText;
                                noCheckList = false;
                              });
                            },
                          ),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: level2softdp,
                          ),
                        ),
                        DialogButton(
                          child: Text(
                            'Create',
                            style: level2softw,
                          ),
                          radius: BorderRadius.circular(100),
                          onPressed: () async {
                            var input = birdInput.trim();
                            if (input != '') {
                              Firestore.instance
                                  .collection('users')
                                  .document('${prefs.getString('userID')}')
                                  .collection('userChecklists')
                                  .document(input)
                                  .setData({
                                'birds': [],
                              });
                              // userChecklists.document('$input').setData({
                              //   'birds': [],
                              // });

                              setState(() {
                                checkList.add(input);
                                birdInput = '';
                              });
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  action: SnackBarAction(
                                      label: 'OK', onPressed: () {}),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: darkPurple,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'You entered nothing.',
                                    style: level2softw,
                                  )));
                            }
                            Navigator.of(context).pop();
                          },
                          color: softGreen,
                        )
                      ],
                    ).show();
                  }),
            ),
          ],
        ),
        signedIn
            ? loading
                ? Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 50),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(darkPurple),
                        strokeWidth: 2.0,
                      ),
                    ),
                  )
                : noCheckList
                    ? noNotesWidget()
                    : Container(
                        height: checkList.length <= 7
                            ? (checkList.length * 110).toDouble()
                            : (checkList.length * 80).toDouble(),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: checkList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: Duration(milliseconds: 300),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      decoration: BoxDecoration(
                                        color: Color(0xfff5f5f5),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(-6.00, -6.00),
                                            color: Color(0xffffffff)
                                                .withOpacity(0.80),
                                            blurRadius: 10,
                                          ),
                                          BoxShadow(
                                            offset: Offset(6.00, 6.00),
                                            color: Color(0xff000000)
                                                .withOpacity(0.20),
                                            blurRadius: 10,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(15.00),
                                      ),
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        direction: DismissDirection.startToEnd,
                                        onDismissed: (dismissDirection) async {
                                          await Firestore.instance
                                              .collection('users')
                                              .document(
                                                  '${prefs.getString('userID')}')
                                              .collection('userChecklists')
                                              .document('${checkList[index]}')
                                              .delete();
                                          setState(() {
                                            checkList.removeAt(index);
                                            if (checkList.length == 0) {
                                              noCheckList = true;
                                            }
                                          });
                                        },
                                        background: dismissedBackground(),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 2, bottom: 2, right: 15),
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type:
                                                      PageTransitionType.scale,
                                                  alignment: Alignment.center,
                                                  child: CheckListBirds(
                                                    checklist: checkList[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            leading: Icon(
                                              Icons.playlist_add_check,
                                              color: softGreen,
                                            ),
                                            title: Text(
                                              "${checkList[index]}",
                                              style: level2softdp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
            : NotSignedInWidget(
                text: "Sign in to view your checklists.",
              ),
      ],
    );
  }
}
