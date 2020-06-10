// import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart';
import 'package:googleapis/ml/v1.dart';

class Classification {
  final secretPATH = "assets/secrets/google-cloud.json";

  ServiceAccountCredentials _credentials;

  static const _SCOPE = [MlApi.CloudPlatformScope];

  static const _PROJECT_ID = 'fyp-sj24';
  static const _MODEL_NAME = 'CloudImageClassification';

  Classification._() {
    getCredentials();
  }

  static Classification instance = Classification._();

  Future<List> predict(List<String> imagePath) async {
    // var tS = DateTime.now().millisecondsSinceEpoch;

    var i = [];

    for (String s in imagePath) {
      var file = new File(s);
      var imageB64 = base64Encode(await file.readAsBytes());
      i.add({"b64": imageB64});
    }

    var reqData = {"instances": i};

    http.Client _client = await clientViaServiceAccount(_credentials, _SCOPE)
        .then<http.Client>((httpClient) => httpClient);

    var requester =
        ApiRequester(_client, "https://ml.googleapis.com/", "", 'dart_api');

    var response = await requester.request(
        "v1/projects/$_PROJECT_ID/models/$_MODEL_NAME:predict", "POST",
        body: json.encode(reqData));

    // print(
    //     'LOG: Prediction Time: ${(DateTime.now().millisecondsSinceEpoch - tS) / 1000}s');
    return response['predictions'];
  }

  void getCredentials() async {
    _credentials = new ServiceAccountCredentials.fromJson(
        await rootBundle.loadString(secretPATH));
  }
}
