import 'dart:io';
// import 'package:animations/animations.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/components/dimissed_background.dart';
import 'package:aibirdie/screens/Dashboard/chips/image_full.dart';

class ImageChip extends StatefulWidget {
  @override
  _ImageChipState createState() => _ImageChipState();
}

class _ImageChipState extends State<ImageChip> {
  // String data;
  // String info;

  var images = [];

  // static var imageCollections = [];
  // static var infos = [];

  @override
  void initState() {
    readImages();
    super.initState();
  }

  Future<void> readImages() async {
    Directory imgDir = Directory('/storage/emulated/0/AiBirdie/Images');
    var temp = imgDir.list();
    images = await temp.toList();
    setState(() {});
  }

  Future<void> deleteImage(index) async {
    File f = images[index];
    await f.delete();
    readImages();
  }

  @override
  Widget build(BuildContext context) {
    return images.length == 0
        ? Container(
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
                    Icons.photo_album,
                    size: 40,
                    color: softGreen,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "No images to show.",
                        style: level2softdp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Click on",
                            style: level2softdp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          Text(
                            "to take one.",
                            style: level2softdp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: (images.length * 130).toDouble(),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: images.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 300),
                  child: ScaleAnimation(
                    scale: 1.5,
                    child: FadeInAnimation(
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: 15,
                        ),
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
                        child: Dismissible(
                          key: UniqueKey(),
                          background: dismissedBackground(),
                          onDismissed: (a) {
                            deleteImage(index);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            fullscreenDialog: false,
                                            builder: (context) {
                                              return ImageFull(
                                                inp: images[index],
                                              );
                                            }),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Material(
                                        elevation: 5.0,
                                        // color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Hero(
                                          tag: '${images[index].path}',
                                          child: CircleAvatar(
                                            radius: 28,
                                            backgroundImage:
                                                FileImage(images[index]),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  titleWidget(images[index]),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteImage(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget titleWidget(File f) {
    return Text(
      DateFormat("dd MMM, yyyy").format(f.lastModifiedSync()) +
          " " +
          DateFormat("H:mm").format(f.lastModifiedSync()),
      style: level2softdp,
    );
  }
}
