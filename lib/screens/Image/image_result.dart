import 'dart:io';
import 'package:aibirdie/screens/Image/zoom_image.dart';
import 'package:aibirdie/screens/landing_page.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ai_birdie_image/aibirdieimage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/Image/trivia_screen.dart';
import 'package:aibirdie/services/id_to_label.dart';

class ImageResult extends StatefulWidget {
  final List<String> imageInputFiles;
  ImageResult({this.imageInputFiles});
  @override
  _ImageResultState createState() => _ImageResultState();
}

class _ImageResultState extends State<ImageResult>
    with SingleTickerProviderStateMixin {
  PageController pc = PageController(initialPage: 0);
  PageController ipc = PageController(initialPage: 0);

  var isOnline = false;
  var predictionResult;
  var showImages = false;

  @override
  void initState() {
    super.initState();
    _doPrediction();
    setImageFlag();
  }

  void setImageFlag() async {
    var settings = await Firestore.instance
        .collection('settings')
        .document('config')
        .get();
    setState(() => showImages = settings.data['showImages']);
  }

  void _doPrediction() async {
    var classifier = AIBirdieImage.classification();

    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() => isOnline = !(connectivityResult == ConnectivityResult.none));

    if (isOnline) {
      predictionResult = await classifier.predict(widget.imageInputFiles);
      setState(() => ImagePrediction.processResult(predictionResult));
    } else {
      predictionResult =
          await classifier.predictOffline(widget.imageInputFiles);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: softGreen,
        title: Text(
          "Top 20 Results",
          style: level2softw,
        ),
        centerTitle: true,
        bottom: headerWidget(context),
      ),
      body: WillPopScope(
        onWillPop: _willPopCallback,
        child: isOnline ? onlineResults() : offlineResults(),
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(100, MediaQuery.of(context).size.height * 0.2 + 10),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        color: softGreen,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Visibility(
                  visible: widget.imageInputFiles.length == 1 ? false : true,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: RaisedButton(
                      disabledColor: Colors.grey,
                      onPressed: () {
                        ipc.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                        pc.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      },
                      color: darkPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: PageView(
                    onPageChanged: (index) {
                      pc.animateToPage(index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    },
                    controller: ipc,
                    children: <Widget>[
                      for (var image in widget.imageInputFiles)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageTransition(
                                  child: ZoomImage(
                                    label: "Captured Image",
                                    image: FileImage(File(image)),
                                  ),
                                  type: PageTransitionType.fade),
                            );
                          },
                          child: Hero(
                            tag: image,
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              // elevation: 5.0,
                              child: CircleAvatar(
                                backgroundColor: darkPurple,
                                backgroundImage: FileImage(
                                  File(image),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.imageInputFiles.length == 1 ? false : true,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: RaisedButton(
                      disabledColor: Colors.grey,
                      onPressed: () {
                        ipc.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                        pc.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      },
                      color: darkPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget onlineResults() {
    return StreamBuilder<List<ImagePrediction>>(
      stream: ImagePrediction.predictions,
      builder: (context, predictions) =>
          !predictions.hasData || predictions.data.length == 0
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkPurple),
                    strokeWidth: 2.0,
                  ),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: PageView(
                          onPageChanged: (index) {
                            ipc.animateToPage(index,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut);
                          },
                          controller: pc,
                          children: loadOnlineWidgets(predictions.data)),
                    ),
                  ],
                ),
    );
  }

  Widget offlineResults() {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView(
              onPageChanged: (index) {
                ipc.animateToPage(index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
              controller: pc,
              children: loadOfflineWidgets()),
        ),
      ],
    );
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
                          showImages: showImages,
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
    // setState(() => loading = true);

    List<OfflineResult> results = [];

    if (predictionResult != null) {
      setState(() {
        for (Map pred in predictionResult) {
          results
              .add(OfflineResult(ids: pred['id'], accs: pred['probabilities']));
        }
        // loading = false;
      });
    }

    List<Widget> ret = [];

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
            itemCount: results[i].ids.length,
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
                      //       accuracy: results[i].accs[index],
                      //       accuracyString: "${results[i].accs[index]}",
                      //       // docSpecies: null,
                      //       id: results[i].ids[index],
                      //       // label: null,
                      //       inputImageFile: File(widget.imageInputFiles[i]),
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
                              idToLabel("${results[i].ids[index]}"),
                              style: level2softdp,
                            ),
                            Text(
                              "${(results[i].accs[index] * 100.0).toStringAsFixed(3)} %",
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

  Future<bool> _willPopCallback() async {
    // await ImagePrediction._predictionSubject.close();

    List<CameraDescription> cameras;
    cameras = await availableCameras();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LandingPage(cameras)),
        (route) => false);
    return true;
  }
}

class ImagePrediction {
  static Firestore db = Firestore.instance;
  static CollectionReference refBirdSpecies = db.collection("bird-species-new");

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

class OfflineResult {
  final List ids;
  final List accs;
  OfflineResult({this.ids, this.accs});
}
