import 'dart:io';

import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/Audio/audio_identify.dart';
import 'package:aibirdie/screens/Image/image_result.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadFile extends StatefulWidget {
  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: darkPurple,
        ),
        centerTitle: true,
        backgroundColor: Color(0xfffafafa),
        elevation: 0.0,
        title: Text(
          "Upload file",
          style: level2softdp.copyWith(fontSize: 20),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(0xfffafafa),
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
                borderRadius: BorderRadius.circular(100.00),
              ),
              height: 100,
              width: 100,
              child: OutlineButton(
                highlightedBorderColor: softGreen,
                borderSide: BorderSide(
                    style: BorderStyle.solid, color: darkPurple, width: 1.5),
                color: darkPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_photo_alternate,
                      color: darkPurple,
                      size: 30,
                    ),
                    Text(
                      "Image",
                      style: level2softdp,
                    ),
                  ],
                ),
                onPressed: () async {
                  File image;
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);
                  image = File(pickedFile.path);
                  if (image != null)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageResult(imageInputFiles: [image.path],),
                      ),
                    );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xfffafafa),
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
                borderRadius: BorderRadius.circular(100.00),
              ),
              height: 100,
              width: 100,
              child: OutlineButton(
                highlightedBorderColor: softGreen,
                borderSide: BorderSide(
                    style: BorderStyle.solid, color: darkPurple, width: 1.5),
                color: darkPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.music_note,
                      color: darkPurple,
                      size: 30,
                    ),
                    Text(
                      "Audio",
                      style: level2softdp,
                    ),
                  ],
                ),
                onPressed: () async {
                  File file = await FilePicker.getFile(
                    type: FileType.audio,
                  );
                  if (file != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AudioIdentify(file: file,)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
