import 'dart:io';
// import 'dart:typed_data';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:aibirdie/screens/Image/zoom_image.dart';
import 'package:firebase_image/firebase_image.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aibirdie/constants.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:googleapis/storage/v1.dart';
// import 'package:googleapis_auth/auth_io.dart';

class TriviaScreen extends StatefulWidget {
  final int id;
  final int index;
  final String label;
  final double accuracy;
  final String accuracyString;
  final DocumentSnapshot docSpecies;
  final File inputImageFile;
  final bool showImages;

  TriviaScreen({
    this.index,
    this.id,
    this.label,
    this.accuracy,
    this.accuracyString,
    this.docSpecies,
    this.inputImageFile,
    this.showImages,
  });
  @override
  _TriviaScreenState createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  CollectionReference refImages = Firestore.instance.collection("images");

  List<String> imageStrings = [];
  List<DocumentSnapshot> imagesDocs;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  void fetchImages() async {

    imagesDocs = await Firestore.instance
        .collection('bird-species')
        .document(widget.docSpecies.documentID)
        .collection('images')
        .getDocuments()
        .then((value) => value.documents);

    setState(() {
      for (var i in imagesDocs) {
        imageStrings.add("gs://aibirdie-app/data/images/${i.documentID}");
        if (imageStrings.length == 9) break;
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("id: ${widget.id}");
    // print("label: ${widget.label}");
    // print("accuracy: ${widget.accuracy}");
    // print("accuracyString: ${widget.accuracyString}");
    // // print("docSpecies: ${widget.docSpecies.collection('images')}");
    // print("inputImageFile: ${widget.inputImageFile}");

    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.label,
          style: level2softw.copyWith(fontSize: 20),
        ),
        elevation: 0.0,
        backgroundColor: softGreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      // height: mediaQuery.height * 0.15,
                      // height: double.infinity,
                      width: double.infinity,
                      color: softGreen,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Rank ${widget.index.toString()}",
                                  style: level2softw.copyWith(fontSize: 15),
                                ),
                                Text(
                                  widget.accuracyString,
                                  style: level2softw.copyWith(fontSize: 15),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      "Trivia",
                      style: level2softdp.copyWith(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(10),
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
                      child:
                          // Center(child: Text("data")),

                          ListView(
                        children: <Widget>[
                          Text(
                            widget.docSpecies.data['trivia'],
                            style: level2softdp,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.showImages,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 20),
                      child: Text(
                        "Similar images",
                        style: level2softdp.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.showImages,
                    child: Expanded(
                      flex: 3,
                      child: _loading
                          ? Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(darkPurple),
                                strokeWidth: 2.0,
                              )),
                            )
                          : Container(
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
                              child: GridView.builder(
                                // scrollDirection: Axis.horizontal,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: imageStrings.length,
                                padding: EdgeInsets.all(5),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageTransition(
                                            child: ZoomImage(
                                              label: widget.label,
                                              image: FirebaseImage(
                                                imageStrings[index],
                                              ),
                                            ),
                                            type: PageTransitionType.fade),
                                      );
                                    },
                                    splashColor: softGreen,
                                    child: GridTile(
                                      header: Container(
                                        margin:
                                            EdgeInsets.only(right: 85, top: 10),
                                        child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: darkPurple,
                                            child: Text(
                                              "${index + 1}",
                                              style: level2softw.copyWith(
                                                  fontSize: 10),
                                            )),
                                      ),
                                      child: Hero(
                                        tag: FirebaseImage(imageStrings[index]),
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: FirebaseImage(
                                                    imageStrings[index]),
                                                fit: BoxFit.cover),
                                          ),

                                          // child: Image(
                                          //   fit: BoxFit.cover,
                                          //   image: FirebaseImage(
                                          //       imageStrings[index]),
                                          //   loadingBuilder:
                                          //       (BuildContext context,
                                          //           Widget child,
                                          //           ImageChunkEvent
                                          //               loadingProgress) {
                                          //     if (loadingProgress == null){
                                          //       return child;
                                          //     }
                                          //     return Center(
                                          //       child:
                                          //           CircularProgressIndicator(
                                          //         value: loadingProgress
                                          //                     .expectedTotalBytes !=
                                          //                 null
                                          //             ? loadingProgress
                                          //                     .cumulativeBytesLoaded /
                                          //                 loadingProgress
                                          //                     .expectedTotalBytes
                                          //             : null,
                                          //       ),
                                          //     );
                                          //   },
                                          // ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        color: darkPurple,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: Text(
                          "Back to results",
                          style: level2softw,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: mediaQuery.aspectRatio > (9 / 16)
                    ? mediaQuery.height * 0.15 - 100
                    : mediaQuery.height * 0.15 - 90,
                child: Hero(
                  tag: widget.inputImageFile.path,
                  child: Material(
                    borderRadius: BorderRadius.circular(100),
                    elevation: 10.0,
                    child: CircleAvatar(
                      backgroundColor: softGreen,
                      radius: mediaQuery.aspectRatio > (9 / 16) ? 70 : 60,
                      onBackgroundImageError: (exception, stackTrace) {
                        return CircularProgressIndicator();
                      },
                      backgroundImage: FileImage(
                        widget.inputImageFile,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
