///
//  Generated code. Do not modify.
//  source: service/service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'service.pb.dart' as $0;
export 'service.pb.dart';

class HelloServiceClient extends $grpc.Client {
  static final _$hello = $grpc.ClientMethod<$0.HelloRequest, $0.HelloResponse>(
      '/HelloService/hello',
      ($0.HelloRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HelloResponse.fromBuffer(value));

  HelloServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.HelloResponse> hello($0.HelloRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$hello, request, options: options);
  }
}

// abstract class HelloServiceBase extends $grpc.Service {
//   $core.String get $name => 'HelloService';
//
//   HelloServiceBase() {
//     $addMethod($grpc.ServiceMethod<$0.HelloRequest, $0.HelloResponse>(
//         'hello',
//         hello_Pre,
//         false,
//         false,
//         ($core.List<$core.int> value) => $0.HelloRequest.fromBuffer(value),
//         ($0.HelloResponse value) => value.writeToBuffer()));
//   }
//
//   $async.Future<$0.HelloResponse> hello_Pre(
//       $grpc.ServiceCall call, $async.Future<$0.HelloRequest> request) async {
//     return hello(call, await request);
//   }
//
//   $async.Future<$0.HelloResponse> hello(
//       $grpc.ServiceCall call, $0.HelloRequest request);
// }
