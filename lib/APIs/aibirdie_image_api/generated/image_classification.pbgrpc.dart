///
//  Generated code. Do not modify.
//  source: image_classification.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'image_classification.pb.dart' as $0;
export 'image_classification.pb.dart';

class ImageClassificationServiceClient extends $grpc.Client {
  static final _$classify = $grpc.ClientMethod<$0.ImageClassificationRequest,
          $0.ImageClassificationResponse>(
      '/aibirdie.image_classification.ImageClassificationService/Classify',
      ($0.ImageClassificationRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.ImageClassificationResponse.fromBuffer(value));

  ImageClassificationServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.ImageClassificationResponse> classify(
      $0.ImageClassificationRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$classify, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class ImageClassificationServiceBase extends $grpc.Service {
  $core.String get $name =>
      'aibirdie.image_classification.ImageClassificationService';

  ImageClassificationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ImageClassificationRequest,
            $0.ImageClassificationResponse>(
        'Classify',
        classify_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ImageClassificationRequest.fromBuffer(value),
        ($0.ImageClassificationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ImageClassificationResponse> classify_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ImageClassificationRequest> request) async {
    return classify(call, await request);
  }

  $async.Future<$0.ImageClassificationResponse> classify(
      $grpc.ServiceCall call, $0.ImageClassificationRequest request);
}
