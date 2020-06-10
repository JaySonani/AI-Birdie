import 'dart:io';
import 'package:aibirdie/components/not_signedIn_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/components/dimissed_background.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  final controller = TextEditingController();
  final notesFile = File('/storage/emulated/0/AiBirdie/Notes/notes.txt');
  var noNotes = false;
  SharedPreferences prefs;
  bool loading = true;
  String userID;

  var _notes = [];

  @override
  void initState() {
    super.initState();
    // readNotesFile();
    fetchData();
  }

  void fetchData() async {
    prefs = await SharedPreferences.getInstance();
    if(signedIn){
      userID = prefs.getString('userID');
      readNote();
    }
    setState(() {
      loading = true;
    });
  }

  // void readNotesFile() async {
  //   var value = await readContentsByLine(notesFile);
  //   setState(() {
  //     if (value.length == 0) {
  //       noNotes = true;
  //     } else {
  //       _notes = value;
  //       noNotes = false;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            color: softGreen,
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
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: TextField(
              controller: controller,
              style: level2softw,
              cursorColor: darkPurple,
              decoration: InputDecoration(
                hintText: "Add a new note...",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              onSubmitted: (newText) async {
                controller.clear();
                var input = newText.trim();
                if (input != '') {
                  if(signedIn)
                  addNote(input);
                  else{
                  Scaffold.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(label: 'OK', onPressed: () {}),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: darkPurple,
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Sign in to view and add new notes.',
                        style: level2softw,
                      )));
                  }

                  setState(() {
                    _notes.add(input);
                    noNotes = false;
                  });
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(label: 'OK', onPressed: () {}),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: darkPurple,
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Empty note cannot be added to the list.',
                        style: level2softw,
                      )));
                }

                // Navigator.of(context).pop();
              },
            ),
          ),
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
                : noNotes
                    ? noNotesWidget()
                    : Container(
                        height: _notes.length <= 7
                            ? (_notes.length * 110).toDouble()
                            : (_notes.length * 80).toDouble(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _notes.length,
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
                                      direction: DismissDirection.startToEnd,
                                      background: dismissedBackground(),
                                      onDismissed: (dismissDirection) {
                                        deleteNote(index);

                                        // fetchData();

                                        // deleteNoteAt(index);
                                      },
                                      key: UniqueKey(),
                                      child: ListTile(
                                        // leading: Text("${index + 1}"),
                                        title: Text(
                                          _notes[index],
                                          style: level2softdp,
                                        ),

                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            deleteNote(index);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
            : NotSignedInWidget(text: "Sign in to view your notes here.",),
      ],
    );
  }


  void readNote() {
    Firestore.instance.collection('users').document(userID).get().then((value) {
      if (value.exists) {
        setState(() {
          _notes.addAll(value.data['userNotes']);
          loading = false;
          if (_notes.length == 0) noNotes = true;
        });
      }
    }).catchError((e) {
      print("Error: $e");
    });
  }

  void addNote(String input) {
    Firestore.instance.collection('users').document(userID).updateData({
      'userNotes': FieldValue.arrayUnion([input]),
    }).catchError((e) {
      print("Error: $e");
    });
  }

  void deleteNote(int index) {
    try {
      Firestore.instance.collection('users').document(userID).updateData({
        'userNotes': FieldValue.arrayRemove([_notes[index]]),
      });
      setState(() {
        _notes.removeAt(index);
        if (_notes.length == 0) noNotes = true;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future<void> deleteNoteAt(int index) async {
  //   _notes.removeAt(index);
  //   String temp = "";
  //   for (var everyNote in _notes) temp = temp + everyNote + "\n";
  //   await clearFile(notesFile);
  //   await appendContent(notesFile, temp);
  //   var value = await readContentsByLine(notesFile);
  //   setState(() => _notes = value);
  //   if (_notes.length == 0) {
  //     setState(() => noNotes = true);
  //   }
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
              Icons.text_fields,
              size: 40,
              color: softGreen,
            ),
            Column(
              children: <Widget>[
                Text(
                  "You have not added any notes yet.",
                  style: level2softdp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
