///
//  Generated code. Do not modify.
//  source: image_classification.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ImageClassificationRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ImageClassificationRequest', package: const $pb.PackageName('aibirdie.image_classification'), createEmptyInstance: create)
    ..aOS(1, 'imageData', protoName: 'imageData')
    ..hasRequiredFields = false
  ;

  ImageClassificationRequest._() : super();
  factory ImageClassificationRequest() => create();
  factory ImageClassificationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageClassificationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ImageClassificationRequest clone() => ImageClassificationRequest()..mergeFromMessage(this);
  ImageClassificationRequest copyWith(void Function(ImageClassificationRequest) updates) => super.copyWith((message) => updates(message as ImageClassificationRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ImageClassificationRequest create() => ImageClassificationRequest._();
  ImageClassificationRequest createEmptyInstance() => create();
  static $pb.PbList<ImageClassificationRequest> createRepeated() => $pb.PbList<ImageClassificationRequest>();
  @$core.pragma('dart2js:noInline')
  static ImageClassificationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageClassificationRequest>(create);
  static ImageClassificationRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get imageData => $_getSZ(0);
  @$pb.TagNumber(1)
  set imageData($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasImageData() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageData() => clearField(1);
}

class Result extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Result', package: const $pb.PackageName('aibirdie.image_classification'), createEmptyInstance: create)
    ..a<$core.int>(1, 'classId', $pb.PbFieldType.OU3)
    ..aOS(2, 'label')
    ..a<$core.int>(3, 'rank', $pb.PbFieldType.OU3)
    ..a<$core.double>(4, 'percent', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Result._() : super();
  factory Result() => create();
  factory Result.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Result.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Result clone() => Result()..mergeFromMessage(this);
  Result copyWith(void Function(Result) updates) => super.copyWith((message) => updates(message as Result));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Result create() => Result._();
  Result createEmptyInstance() => create();
  static $pb.PbList<Result> createRepeated() => $pb.PbList<Result>();
  @$core.pragma('dart2js:noInline')
  static Result getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Result>(create);
  static Result _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get classId => $_getIZ(0);
  @$pb.TagNumber(1)
  set classId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClassId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get rank => $_getIZ(2);
  @$pb.TagNumber(3)
  set rank($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRank() => $_has(2);
  @$pb.TagNumber(3)
  void clearRank() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get percent => $_getN(3);
  @$pb.TagNumber(4)
  set percent($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearPercent() => clearField(4);
}

class ImageClassificationResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ImageClassificationResponse', package: const $pb.PackageName('aibirdie.image_classification'), createEmptyInstance: create)
    ..pc<Result>(1, 'results', $pb.PbFieldType.PM, subBuilder: Result.create)
    ..hasRequiredFields = false
  ;

  ImageClassificationResponse._() : super();
  factory ImageClassificationResponse() => create();
  factory ImageClassificationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageClassificationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ImageClassificationResponse clone() => ImageClassificationResponse()..mergeFromMessage(this);
  ImageClassificationResponse copyWith(void Function(ImageClassificationResponse) updates) => super.copyWith((message) => updates(message as ImageClassificationResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ImageClassificationResponse create() => ImageClassificationResponse._();
  ImageClassificationResponse createEmptyInstance() => create();
  static $pb.PbList<ImageClassificationResponse> createRepeated() => $pb.PbList<ImageClassificationResponse>();
  @$core.pragma('dart2js:noInline')
  static ImageClassificationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageClassificationResponse>(create);
  static ImageClassificationResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Result> get results => $_getList(0);
}

