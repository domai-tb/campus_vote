//
//  Generated code. Do not modify.
//  source: vote.proto
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

import 'common.pb.dart' as $1;
import 'vote.pb.dart' as $0;

export 'vote.pb.dart';

@$pb.GrpcServiceName('CampusVote.Vote')
class VoteClient extends $grpc.Client {
  static final _$createVoter = $grpc.ClientMethod<$0.Voter, $1.StatusCode>(
      '/CampusVote.Vote/CreateVoter',
      ($0.Voter value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.StatusCode.fromBuffer(value));
  static final _$getVoterByStudentId = $grpc.ClientMethod<$0.StudentId, $0.Voter>(
      '/CampusVote.Vote/GetVoterByStudentId',
      ($0.StudentId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Voter.fromBuffer(value));
  static final _$registerVote = $grpc.ClientMethod<$0.VoteReq, $1.StatusCode>(
      '/CampusVote.Vote/RegisterVote',
      ($0.VoteReq value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.StatusCode.fromBuffer(value));
  static final _$checkVoterStatus = $grpc.ClientMethod<$0.StudentId, $1.StatusCode>(
      '/CampusVote.Vote/CheckVoterStatus',
      ($0.StudentId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.StatusCode.fromBuffer(value));
  static final _$getElectionStats = $grpc.ClientMethod<$1.Void, $0.ElectionStats>(
      '/CampusVote.Vote/GetElectionStats',
      ($1.Void value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ElectionStats.fromBuffer(value));

  VoteClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$1.StatusCode> createVoter($0.Voter request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createVoter, request, options: options);
  }

  $grpc.ResponseFuture<$0.Voter> getVoterByStudentId($0.StudentId request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getVoterByStudentId, request, options: options);
  }

  $grpc.ResponseFuture<$1.StatusCode> registerVote($0.VoteReq request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerVote, request, options: options);
  }

  $grpc.ResponseFuture<$1.StatusCode> checkVoterStatus($0.StudentId request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$checkVoterStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.ElectionStats> getElectionStats($1.Void request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getElectionStats, request, options: options);
  }
}

@$pb.GrpcServiceName('CampusVote.Vote')
abstract class VoteServiceBase extends $grpc.Service {
  $core.String get $name => 'CampusVote.Vote';

  VoteServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Voter, $1.StatusCode>(
        'CreateVoter',
        createVoter_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Voter.fromBuffer(value),
        ($1.StatusCode value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StudentId, $0.Voter>(
        'GetVoterByStudentId',
        getVoterByStudentId_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StudentId.fromBuffer(value),
        ($0.Voter value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VoteReq, $1.StatusCode>(
        'RegisterVote',
        registerVote_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.VoteReq.fromBuffer(value),
        ($1.StatusCode value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StudentId, $1.StatusCode>(
        'CheckVoterStatus',
        checkVoterStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StudentId.fromBuffer(value),
        ($1.StatusCode value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Void, $0.ElectionStats>(
        'GetElectionStats',
        getElectionStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Void.fromBuffer(value),
        ($0.ElectionStats value) => value.writeToBuffer()));
  }

  $async.Future<$1.StatusCode> createVoter_Pre($grpc.ServiceCall call, $async.Future<$0.Voter> request) async {
    return createVoter(call, await request);
  }

  $async.Future<$0.Voter> getVoterByStudentId_Pre($grpc.ServiceCall call, $async.Future<$0.StudentId> request) async {
    return getVoterByStudentId(call, await request);
  }

  $async.Future<$1.StatusCode> registerVote_Pre($grpc.ServiceCall call, $async.Future<$0.VoteReq> request) async {
    return registerVote(call, await request);
  }

  $async.Future<$1.StatusCode> checkVoterStatus_Pre($grpc.ServiceCall call, $async.Future<$0.StudentId> request) async {
    return checkVoterStatus(call, await request);
  }

  $async.Future<$0.ElectionStats> getElectionStats_Pre($grpc.ServiceCall call, $async.Future<$1.Void> request) async {
    return getElectionStats(call, await request);
  }

  $async.Future<$1.StatusCode> createVoter($grpc.ServiceCall call, $0.Voter request);
  $async.Future<$0.Voter> getVoterByStudentId($grpc.ServiceCall call, $0.StudentId request);
  $async.Future<$1.StatusCode> registerVote($grpc.ServiceCall call, $0.VoteReq request);
  $async.Future<$1.StatusCode> checkVoterStatus($grpc.ServiceCall call, $0.StudentId request);
  $async.Future<$0.ElectionStats> getElectionStats($grpc.ServiceCall call, $1.Void request);
}
