import 'dart:io';
import 'package:aibirdie/APIs/aibirdie_audio_api/request.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AudioResult extends StatefulWidget {
  final File file;
  AudioResult(this.file);
  @override
  AudioResultState createState() => AudioResultState();
}

class AudioResultState extends State<AudioResult> {
  bool _showSpinner = true;
  var labels = [];
  var accuracy = [];
  AiBirdieAudioClassification abac;

  @override
  void initState() {
    predictBird();
    super.initState();
  }

  Future<void> predictBird() async {
    abac = AiBirdieAudioClassification(inputFile: widget.file);
    var result = await abac.predict();
    // print('Result: $result');

    setState(() {
      labels.add(result['0'].toString().split(":").first.substring(1));
      labels.add(result['1'].toString().split(":").first.substring(1));
      labels.add(result['2'].toString().split(":").first.substring(1));

      accuracy.add(
          '${result['0'].toString().split(":").last.substring(0, result['0'].toString().split(":").last.length - 1)} %');
      accuracy.add(
          '${result['1'].toString().split(":").last.substring(0, result['1'].toString().split(":").last.length - 1)} %');
      accuracy.add(
          '${result['2'].toString().split(":").last.substring(0, result['2'].toString().split(":").last.length - 1)} %');

      _showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(darkPurple),
          strokeWidth: 2.0,
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Results",
                      style: level2softg.copyWith(
                          fontSize: 35, fontFamily: 'OS_semi_bold'),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.only(top: 200),
                itemCount: labels.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
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
                                    accuracy[index],
                                    style: level2softdp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
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
            ],
          ),
        ),
      ),
    );
  }
}
