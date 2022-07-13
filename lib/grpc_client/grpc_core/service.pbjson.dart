///
//  Generated code. Do not modify.
//  source: service/service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use helloRequestDescriptor instead')
const HelloRequest$json = const {
  '1': 'HelloRequest',
  '2': const [
    const {'1': 'firstName', '3': 1, '4': 1, '5': 9, '10': 'firstName'},
    const {'1': 'lastName', '3': 2, '4': 1, '5': 9, '10': 'lastName'},
  ],
};

/// Descriptor for `HelloRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloRequestDescriptor = $convert.base64Decode('CgxIZWxsb1JlcXVlc3QSHAoJZmlyc3ROYW1lGAEgASgJUglmaXJzdE5hbWUSGgoIbGFzdE5hbWUYAiABKAlSCGxhc3ROYW1l');
@$core.Deprecated('Use helloResponseDescriptor instead')
const HelloResponse$json = const {
  '1': 'HelloResponse',
  '2': const [
    const {'1': 'greeting', '3': 1, '4': 1, '5': 9, '10': 'greeting'},
  ],
};

/// Descriptor for `HelloResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloResponseDescriptor = $convert.base64Decode('Cg1IZWxsb1Jlc3BvbnNlEhoKCGdyZWV0aW5nGAEgASgJUghncmVldGluZw==');
