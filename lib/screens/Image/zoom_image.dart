import 'package:aibirdie/constants.dart';
import 'package:flutter/material.dart';

class ZoomImage extends StatelessWidget {
  final ImageProvider image;
  final String label;
  ZoomImage({this.image, this.label});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: Container(),
        title: Text(
          label,
          style: level2softw.copyWith(fontSize: 20),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: image,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 50,
                width: 100,
                child: RaisedButton(
                  child: Center(
                      child: Icon(Icons.arrow_back, color: Colors.white)),
                  color: darkPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
