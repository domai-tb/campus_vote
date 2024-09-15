//
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chat.pb.dart' as $2;
import 'common.pb.dart' as $1;

export 'chat.pb.dart';

@$pb.GrpcServiceName('CampusVote.Chat')
class ChatClient extends $grpc.Client {
  static final _$sendChatMessage = $grpc.ClientMethod<$2.ChatMessage, $1.StatusCode>(
      '/CampusVote.Chat/SendChatMessage',
      ($2.ChatMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.StatusCode.fromBuffer(value));
  static final _$readChatHistory = $grpc.ClientMethod<$1.Void, $2.ChatHistory>(
      '/CampusVote.Chat/ReadChatHistory',
      ($1.Void value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ChatHistory.fromBuffer(value));

  ChatClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$1.StatusCode> sendChatMessage($2.ChatMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendChatMessage, request, options: options);
  }

  $grpc.ResponseFuture<$2.ChatHistory> readChatHistory($1.Void request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$readChatHistory, request, options: options);
  }
}

@$pb.GrpcServiceName('CampusVote.Chat')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'CampusVote.Chat';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.ChatMessage, $1.StatusCode>(
        'SendChatMessage',
        sendChatMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ChatMessage.fromBuffer(value),
        ($1.StatusCode value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Void, $2.ChatHistory>(
        'ReadChatHistory',
        readChatHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Void.fromBuffer(value),
        ($2.ChatHistory value) => value.writeToBuffer()));
  }

  $async.Future<$1.StatusCode> sendChatMessage_Pre($grpc.ServiceCall call, $async.Future<$2.ChatMessage> request) async {
    return sendChatMessage(call, await request);
  }

  $async.Future<$2.ChatHistory> readChatHistory_Pre($grpc.ServiceCall call, $async.Future<$1.Void> request) async {
    return readChatHistory(call, await request);
  }

  $async.Future<$1.StatusCode> sendChatMessage($grpc.ServiceCall call, $2.ChatMessage request);
  $async.Future<$2.ChatHistory> readChatHistory($grpc.ServiceCall call, $1.Void request);
}
