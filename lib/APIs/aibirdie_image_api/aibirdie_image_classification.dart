library aibirdie_image_classification;

import 'dart:io';
import 'dart:convert';

import 'package:grpc/grpc.dart';

import 'generated/image_classification.pb.dart';
import 'generated/image_classification.pbgrpc.dart';

class AiBirdieImageClassification {
  ClientChannel channel;
  ImageClassificationServiceClient stub;

  final String ip;

  AiBirdieImageClassification(this.ip);

  Future<ImageClassificationResponse> predict(String imagePath) async {
    channel = ClientChannel(ip,
          port: 50051,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    stub = ImageClassificationServiceClient(channel,
        options: CallOptions(timeout: Duration(seconds: 30)));
    try {
      var file = new File(imagePath);
      var imageB64 = base64.encode(await file.readAsBytes());

      var req = ImageClassificationRequest()..imageData = imageB64;

      return stub.classify(req);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
