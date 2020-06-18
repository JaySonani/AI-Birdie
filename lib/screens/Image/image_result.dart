import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

import 'package:ai_birdie_image/aibirdieimage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/Image/trivia_screen.dart';

import '../../constants.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

class ImageResult extends StatefulWidget {
  final List<String> imageInputFiles;

  ImageResult({this.imageInputFiles});

  @override
  _ImageResultState createState() => _ImageResultState();
}

class ImagePrediction {
  static Firestore db = Firestore.instance;
  static CollectionReference refBirdSpecies = db.collection("bird-species");

  init() {
    db.settings(persistenceEnabled: true);
  }

  static List<ImagePrediction> _predictions = new List();

  static final _predictionSubject = BehaviorSubject<List<ImagePrediction>>();

  static ValueStream<List<ImagePrediction>> get predictions =>
      _predictionSubject.stream;

  List<int> _ids = [];
  List<String> _labels = [];
  List<double> _accuracy = [];
  List<String> _accuracyStrings = [];
  List<DocumentSnapshot> _docSpecies = [];

  List<int> get ids => _ids;

  List<String> get labels => _labels;

  List<double> get accuracy => _accuracy;

  List<String> get accuracyStrings => _accuracyStrings;

  List<DocumentSnapshot> get docSpecies => _docSpecies;

  ImagePrediction(this._ids, this._labels, this._accuracy,
      this._accuracyStrings, this._docSpecies);

  void _process(Map result) async {
    _ids = List.castFrom<dynamic, int>(result['id']);
    for (var e in ids) {
      docSpecies.add(await refBirdSpecies.document(e.toString()).get());
    }
    _accuracy = List.castFrom<dynamic, double>(result['probabilities']);
    _labels = docSpecies.map<String>((e) => e.data["name"]).toList();
    _accuracyStrings = accuracy
        .map<String>((e) => '${(e * 100.0).toStringAsFixed(3)} %')
        .toList();
    _predictions.add(this);
    _predictionSubject.add(_predictions);
  }

  ImagePrediction.fromResult(Map result) {
    _process(result);
  }

  static void processResult(List<dynamic> results) {
    _predictionSubject.add(null);
    _predictions = List();
    _predictionSubject.add(_predictions);
    for (Map result in results) {
      ImagePrediction.fromResult(result);
    }
  }
}

class _ImageResultState extends State<ImageResult>
    with SingleTickerProviderStateMixin {
  // bool _showSpinner = true;
  TabController tc;
  var isOnline = false;
  var predictionResult;

  // List<Tab> tabs = [];
  // List<Widget> tabBarViews = [];

  @override
  void initState() {
    super.initState();
    _doPrediction();
    tc = TabController(length: widget.imageInputFiles.length, vsync: this);
    // loadWidgets();
  }

  void _doPrediction() async {
    var classifier = AIBirdieImage.classification();

    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() => isOnline = !(connectivityResult == ConnectivityResult.none));

    if (isOnline) {
      predictionResult = await classifier.predict(widget.imageInputFiles);
      setState(() => ImagePrediction.processResult(predictionResult));
    } else {
      classifier.predictOffline(widget.imageInputFiles).then((value) {
        setState(() {
          predictionResult = value;
        });
      });
    }
  }

  List<Widget> loadOnlineWidgets(predictionsData) {
    List<Widget> ret = [];

    for (ImagePrediction prediction in predictionsData)
      ret.add(
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 15,
          ),
          padding: EdgeInsets.all(15),
          itemCount: prediction.ids.length,
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
                          accuracy: prediction.accuracy[index],
                          accuracyString: prediction.accuracyStrings[index],
                          docSpecies: prediction.docSpecies[index],
                          id: prediction.ids[index],
                          label: prediction.labels[index],
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
                            prediction.labels[index],
                            style: level2softdp,
                          ),
                          Text(
                            prediction.accuracyStrings[index],
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
              ),
            );
          },
        ),
      );

    return ret;
  }


  List<Widget> loadOfflineWidgets() {
    List<Widget> ret = [];

    List labels = [];
    // List<String> accString = [];


    // print("Printing from loadOffline: ${predictionResult[1]['id']}");

    if (predictionResult == null) {
      ret.add(
        Center(
          child: Text("Loading"),
        ),
      );
    } else
      for (var i = 0; i < widget.imageInputFiles.length; i++)
        ret.add(
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            padding: EdgeInsets.all(15),
            itemCount: labels.length,
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
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => TriviaScreen(
                      //       accuracy: prediction.accuracy[index],
                      //       accuracyString: prediction.accuracyStrings[index],
                      //       docSpecies: prediction.docSpecies[index],
                      //       id: prediction.ids[index],
                      //       label: prediction.labels[index],
                      //       inputImageFile: File(widget.imageInputFiles[0]),
                      //       index: index + 1,
                      //     ),
                      //   ),
                      // );
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
                              "",
                              // labels[i][index],
                              // prediction.labels[index],
                              style: level2softdp,
                            ),
                            Text(
                              "",
                              // accString[index],
                              // prediction.accuracyStrings[index],
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
                ),
              );
            },
          ),
        );
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Top 20 Results",
          style: level2softw,
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: softGreen,
          indicatorWeight: 5.0,
          labelColor: Colors.white,
          labelStyle: level2softdp,
          unselectedLabelColor: Colors.white,
          unselectedLabelStyle: level2softdp,
          controller: tc,
          tabs: <Widget>[
            for (var i = 0; i < widget.imageInputFiles.length; i++)
              Tab(
                child: Text("${i + 1}"),
              ),
          ],
        ),
      ),
      body: isOnline
          ? StreamBuilder<List<ImagePrediction>>(
              stream: ImagePrediction.predictions,
              builder: (context, predictions) => !predictions.hasData ||
                      predictions.data.length == 0
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(darkPurple),
                        strokeWidth: 2.0,
                      ),
                    )
                  : TabBarView(
                      controller: tc,
                      children: loadOnlineWidgets(predictions.data)),
            )
          : TabBarView(
              controller: tc,
              children: loadOfflineWidgets(),
            ),
    );
  }
}
