//
//  Generated code. Do not modify.
//  source: api.proto
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

import 'api.pb.dart' as $0;

export 'api.pb.dart';

@$pb.GrpcServiceName('CampusVote')
class CampusVoteClient extends $grpc.Client {
  static final _$createVoter = $grpc.ClientMethod<$0.Voter, $0.StatusCode>(
      '/CampusVote/CreateVoter',
      ($0.Voter value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.StatusCode.fromBuffer(value));
  static final _$getVoterByStudentId = $grpc.ClientMethod<$0.StudentId, $0.Voter>(
      '/CampusVote/GetVoterByStudentId',
      ($0.StudentId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Voter.fromBuffer(value));
  static final _$setVoterAsVoted = $grpc.ClientMethod<$0.StudentId, $0.StatusCode>(
      '/CampusVote/SetVoterAsVoted',
      ($0.StudentId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.StatusCode.fromBuffer(value));
  static final _$checkVoterStatus = $grpc.ClientMethod<$0.StudentId, $0.StatusCode>(
      '/CampusVote/CheckVoterStatus',
      ($0.StudentId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.StatusCode.fromBuffer(value));
  static final _$getElectionStats = $grpc.ClientMethod<$0.Void, $0.ElectionStats>(
      '/CampusVote/GetElectionStats',
      ($0.Void value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ElectionStats.fromBuffer(value));

  CampusVoteClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.StatusCode> createVoter($0.Voter request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createVoter, request, options: options);
  }

  $grpc.ResponseFuture<$0.Voter> getVoterByStudentId($0.StudentId request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getVoterByStudentId, request, options: options);
  }

  $grpc.ResponseFuture<$0.StatusCode> setVoterAsVoted($0.StudentId request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setVoterAsVoted, request, options: options);
  }

  $grpc.ResponseFuture<$0.StatusCode> checkVoterStatus($0.StudentId request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$checkVoterStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.ElectionStats> getElectionStats($0.Void request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getElectionStats, request, options: options);
  }
}

@$pb.GrpcServiceName('CampusVote')
abstract class CampusVoteServiceBase extends $grpc.Service {
  $core.String get $name => 'CampusVote';

  CampusVoteServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Voter, $0.StatusCode>(
        'CreateVoter',
        createVoter_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Voter.fromBuffer(value),
        ($0.StatusCode value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StudentId, $0.Voter>(
        'GetVoterByStudentId',
        getVoterByStudentId_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StudentId.fromBuffer(value),
        ($0.Voter value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StudentId, $0.StatusCode>(
        'SetVoterAsVoted',
        setVoterAsVoted_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StudentId.fromBuffer(value),
        ($0.StatusCode value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StudentId, $0.StatusCode>(
        'CheckVoterStatus',
        checkVoterStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StudentId.fromBuffer(value),
        ($0.StatusCode value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Void, $0.ElectionStats>(
        'GetElectionStats',
        getElectionStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Void.fromBuffer(value),
        ($0.ElectionStats value) => value.writeToBuffer()));
  }

  $async.Future<$0.StatusCode> createVoter_Pre($grpc.ServiceCall call, $async.Future<$0.Voter> request) async {
    return createVoter(call, await request);
  }

  $async.Future<$0.Voter> getVoterByStudentId_Pre($grpc.ServiceCall call, $async.Future<$0.StudentId> request) async {
    return getVoterByStudentId(call, await request);
  }

  $async.Future<$0.StatusCode> setVoterAsVoted_Pre($grpc.ServiceCall call, $async.Future<$0.StudentId> request) async {
    return setVoterAsVoted(call, await request);
  }

  $async.Future<$0.StatusCode> checkVoterStatus_Pre($grpc.ServiceCall call, $async.Future<$0.StudentId> request) async {
    return checkVoterStatus(call, await request);
  }

  $async.Future<$0.ElectionStats> getElectionStats_Pre($grpc.ServiceCall call, $async.Future<$0.Void> request) async {
    return getElectionStats(call, await request);
  }

  $async.Future<$0.StatusCode> createVoter($grpc.ServiceCall call, $0.Voter request);
  $async.Future<$0.Voter> getVoterByStudentId($grpc.ServiceCall call, $0.StudentId request);
  $async.Future<$0.StatusCode> setVoterAsVoted($grpc.ServiceCall call, $0.StudentId request);
  $async.Future<$0.StatusCode> checkVoterStatus($grpc.ServiceCall call, $0.StudentId request);
  $async.Future<$0.ElectionStats> getElectionStats($grpc.ServiceCall call, $0.Void request);
}
