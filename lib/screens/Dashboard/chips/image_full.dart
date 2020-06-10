// import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';

class ImageFull extends StatefulWidget {
  final File inp;
  ImageFull({this.inp});

  @override
  _ImageFullState createState() => _ImageFullState();
}

class _ImageFullState extends State<ImageFull> {

  @override
  void initState() {
    super.initState();
    File imageMetaData = File('/storage/emulated/0/AiBirdie/image_metadata.json');
    String fileContent = imageMetaData.readAsStringSync();
    var info = fileContent;
    print(info);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: Color(0xfffafafa),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Text("data"),
              // SizedBox(
              //   height: 20,
              // ),
              Hero(
                tag: widget.inp.path,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Image.file(
                      widget.inp,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Container(
                height: 50,
                width: double.infinity,
                child: RaisedButton(
                    color: softGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Done",
                      style: level2softw,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              )
            ],
          )),
        ),
      ),
    );
  }
}
