import 'package:aibirdie/components/dimissed_background.dart';
import 'package:aibirdie/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckListBirds extends StatefulWidget {
  final String checklist;
  CheckListBirds({this.checklist});

  @override
  _CheckListBirdsState createState() => _CheckListBirdsState();
}

class _CheckListBirdsState extends State<CheckListBirds> {
  bool loading;
  var birds = [];
  var checkedStatus = [];
  String birdInput = '';

  DocumentSnapshot snapShot;
  DocumentReference checkListDoc;

  bool noBirds = false;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    fetchBirds();
  }

  void fetchBirds() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });
    snapShot = await Firestore.instance
        .collection('users')
        .document('${prefs.getString('userID')}')
        .collection('userChecklists')
        .document(widget.checklist)
        .get();

    checkListDoc = Firestore.instance
        .collection('users')
        .document('${prefs.getString('userID')}')
        .collection('userChecklists')
        .document(widget.checklist);

    var birdsarray = await snapShot.data['birds'];

    birds = [];
    checkedStatus = [];
    setState(() {
      for (var i in birdsarray) {
        birds.add(i['birdName']);
        checkedStatus.add(i['checked']);
      }
    });
    if (birds.length == 0) {
      setState(() {
        noBirds = true;
        print("aavyu!");
      });
    }

    print("Birds: $birds");
    print("Checked: $checkedStatus");
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checklist ${widget.checklist}",
          style: level2softw,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: softGreen,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Alert(
              title: 'Add new bird to ${widget.checklist}',
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
                    FontAwesomeIcons.twitter,
                    size: 40,
                    color: softGreen,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'E.g. Blue Jay',
                        hintStyle: TextStyle(fontFamily: 'OS_regular')),
                    style: level2softdp,
                    onChanged: (newText) {
                      setState(() {
                        birdInput = newText;
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
                    'Add',
                    style: level2softw,
                  ),
                  radius: BorderRadius.circular(100),
                  onPressed: () async {
                    var input = birdInput.trim();
                    if (input != '') {
                      Navigator.of(context).pop();
                      setState(() {
                        loading = true;
                      });
                      await checkListDoc.updateData({
                        'birds': FieldValue.arrayUnion([
                          {
                            'birdName': birdInput,
                            'checked': false,
                          }
                        ]),
                      });

                      setState(() {
                        birds.add(birdInput);
                        checkedStatus.add(false);
                        loading = false;
                        noBirds = false;
                        birdInput = '';
                      });
                    } else {
                      Alert(
                        style: AlertStyle(
                          isCloseButton: false,
                          animationType: AnimationType.grow,
                          titleStyle: level2softdp.copyWith(
                            fontSize: 25,
                          ),
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.white,
                            child: Text(
                              "OK",
                              style: level2softdp,
                            ),
                          ),
                        ],
                        type: AlertType.error,
                        title: "You entered nothing.",
                        context: context,
                      ).show();
                      print("Empty input");
                      // Scaffold.of(context).showSnackBar(
                      //   SnackBar(
                      //     action: SnackBarAction(label: 'OK', onPressed: () {}),
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10)),
                      //     backgroundColor: darkPurple,
                      //     behavior: SnackBarBehavior.floating,
                      //     content: Text(
                      //       'You entered nothing.',
                      //       style: level2softw,
                      //     ),
                      //   ),
                      // );
                    }
                  },
                  color: softGreen,
                )
              ],
            ).show();
          }),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        color: darkPurple,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(darkPurple),
          strokeWidth: 2.0,
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Your birds inside ${widget.checklist}",
                        style: level2softdp),
                    Text("${birds.length} birds", style: level2softdp)
                  ],
                ),
              ),
              Divider(
                  // thickness: 1,
                  ),
              noBirds
                  ? noBirdsWidget()
                  : Expanded(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          itemCount: birds.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: Duration(milliseconds: 300),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 20,
                                        bottom: index == birds.length - 1
                                            ? 100
                                            : 0),
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
                                      background: dismissedBackground(),
                                      direction: DismissDirection.startToEnd,
                                      onDismissed: (d) {
                                        checkListDoc.updateData({
                                          'birds': FieldValue.arrayRemove([
                                            {
                                              'birdName': birds[index],
                                              'checked': checkedStatus[index],
                                            }
                                          ])
                                        });
                                        birds.removeAt(index);
                                        fetchBirds();
                                      },
                                      child: CheckboxListTile(
                                        value: checkedStatus[index],
                                        onChanged: (value) {
                                          setState(() {
                                            loading = true;
                                            checkedStatus[index] =
                                                !checkedStatus[index];
                                          });
                                          updateCheckedStatusAt(
                                            index,
                                          );
                                        },
                                        activeColor: softGreen,
                                        title: Text(
                                          "${birds[index]}",
                                          style: level2softdp.copyWith(
                                              decoration: checkedStatus[index]
                                                  ? TextDecoration.lineThrough
                                                  : null),
                                        ),
                                        subtitle: Visibility(
                                          visible: checkedStatus[index],
                                          child: Text(
                                            "Watched",
                                            style: level2softdp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void updateCheckedStatusAt(int index) {
    // Firestore.instance.collection('users').document(globalUserID).collection('userChecklists').document(widget.checklist).updateData({

    //   birds[index]['checked'] :  checkedStatus[index],
    // });

    checkListDoc.updateData({
      'birds': FieldValue.arrayRemove([
        {
          'birdName': birds[index],
          'checked': !checkedStatus[index],
        }
      ])
    });
    checkListDoc.updateData(
      {
        'birds': FieldValue.arrayUnion([
          {
            'birdName': birds[index],
            'checked': checkedStatus[index],
          },
        ])
      },
    );
    setState(() {
      loading = false;
    });
  }

  Widget noBirdsWidget() {
    return Container(
      margin: EdgeInsets.all(15),
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
                  "No birds added in ${widget.checklist}.",
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
