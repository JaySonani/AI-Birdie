///
//  Generated code. Do not modify.
//  source: image_classification.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const ImageClassificationRequest$json = const {
  '1': 'ImageClassificationRequest',
  '2': const [
    const {'1': 'imageData', '3': 1, '4': 1, '5': 9, '10': 'imageData'},
  ],
};

const Result$json = const {
  '1': 'Result',
  '2': const [
    const {'1': 'class_id', '3': 1, '4': 1, '5': 13, '10': 'classId'},
    const {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    const {'1': 'rank', '3': 3, '4': 1, '5': 13, '10': 'rank'},
    const {'1': 'percent', '3': 4, '4': 1, '5': 2, '10': 'percent'},
  ],
};

const ImageClassificationResponse$json = const {
  '1': 'ImageClassificationResponse',
  '2': const [
    const {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.aibirdie.image_classification.Result', '10': 'results'},
  ],
};

