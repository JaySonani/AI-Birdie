import 'dart:io';

import 'package:ai_birdie_image/aibirdieimage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/Image/trivia_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ImageResult extends StatefulWidget {
  final List<String> imageInputFiles;

  ImageResult({this.imageInputFiles});

  @override
  _ImageResultState createState() => _ImageResultState();
}

class _ImageResultState extends State<ImageResult> {
  bool _showSpinner = true;

  List<int> ids = [];
  List<String> labels = [];
  List<double> accuracy = [];
  List<String> accuracyStrings = [];
  List<DocumentSnapshot> docSpecies = [];

  @override
  void initState() {
    super.initState();
    _doPrediction();
  }



  void _doPrediction() async {
    Firestore db = Firestore.instance;
    CollectionReference refBirdSpecies = db.collection("bird-species");

    var classifier = AIBirdieImage.classification();

    var predictionResult = await classifier.predict(widget.imageInputFiles);
    for (Map result in predictionResult) {
      // //
      ids = List.castFrom<dynamic, int>(result['id']);

      for (var e in ids) {
        // //
        docSpecies.add(await refBirdSpecies.document(e.toString()).get());
      }
      // //
      accuracy = List.castFrom<dynamic, double>(result['probabilities']);
    }

    setState(() {
      // //
      labels = docSpecies.map<String>((e) => e.data["name"]).toList();
      // //
      accuracyStrings = accuracy
          .map<String>((e) => '${(e * 100).toString().substring(0, 5)} %')
          .toList();
      _showSpinner = false;
    });

    // saveInfoLocally();
  }

  void saveInfoLocally() {
    Map<String, dynamic> imageData = {};
    String imageID =
        widget.imageInputFiles[0].split("/").last.split(".").first;
    imageData.addAll({
      imageID: {
        'imageFile': widget.imageInputFiles[0],
        'ids': ids,
        'labels': labels,
        'accuracy': accuracy,
        'accStr': accuracyStrings,
        'docSpecies': docSpecies,
      }
    });
    // File imageMetaData = File('/storage/emulated/0/AiBirdie/image_metadata');
    debugPrint(imageData.toString());

  }

  @override
  Widget build(BuildContext context) {
    // print("Labesl: $labels");
    // print("Acc: $accuracyStrings");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Top 20 Results",
          style: level2softw,
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        // color: darkPurple,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(darkPurple),
          strokeWidth: 2.0,
        ),

        inAsyncCall: _showSpinner,
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 15,
          ),
          // physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(15),
          itemCount: ids.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: Center(
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: Color(0xfff5f5f5),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TriviaScreen(
                            accuracy: accuracy[index],
                            accuracyString: accuracyStrings[index],
                            docSpecies: docSpecies[index],
                            id: ids[index],
                            label: labels[index],
                            inputImageFile: File(widget.imageInputFiles[0]),
                            index: index + 1,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${index + 1}",
                          style: level2softdp.copyWith(fontSize: 25),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              labels[index],
                              style: level2softdp,
                            ),
                            Text(
                              accuracyStrings[index],
                              style: level2softdp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // margin:
                // EdgeInsets.only(bottom: 20, left: 30, right: 30),
                height: 70,
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
                ));
          },
        ),
      ),
    );
  }
}
