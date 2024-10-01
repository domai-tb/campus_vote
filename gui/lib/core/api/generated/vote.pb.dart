//
//  Generated code. Do not modify.
//  source: vote.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class StudentId extends $pb.GeneratedMessage {
  factory StudentId({
    $fixnum.Int64? num,
  }) {
    final $result = create();
    if (num != null) {
      $result.num = num;
    }
    return $result;
  }
  StudentId._() : super();
  factory StudentId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StudentId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StudentId', package: const $pb.PackageName(_omitMessageNames ? '' : 'CampusVote'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'num')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StudentId clone() => StudentId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StudentId copyWith(void Function(StudentId) updates) => super.copyWith((message) => updates(message as StudentId)) as StudentId;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StudentId create() => StudentId._();
  StudentId createEmptyInstance() => create();
  static $pb.PbList<StudentId> createRepeated() => $pb.PbList<StudentId>();
  @$core.pragma('dart2js:noInline')
  static StudentId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StudentId>(create);
  static StudentId? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get num => $_getI64(0);
  @$pb.TagNumber(1)
  set num($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNum() => $_has(0);
  @$pb.TagNumber(1)
  void clearNum() => clearField(1);
}

class Voter extends $pb.GeneratedMessage {
  factory Voter({
    $core.String? firstname,
    $core.String? lastname,
    StudentId? studentId,
    $core.String? ballotBox,
    $core.String? faculity,
    $core.int? status,
  }) {
    final $result = create();
    if (firstname != null) {
      $result.firstname = firstname;
    }
    if (lastname != null) {
      $result.lastname = lastname;
    }
    if (studentId != null) {
      $result.studentId = studentId;
    }
    if (ballotBox != null) {
      $result.ballotBox = ballotBox;
    }
    if (faculity != null) {
      $result.faculity = faculity;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  Voter._() : super();
  factory Voter.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Voter.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Voter', package: const $pb.PackageName(_omitMessageNames ? '' : 'CampusVote'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstname')
    ..aOS(2, _omitFieldNames ? '' : 'lastname')
    ..aOM<StudentId>(3, _omitFieldNames ? '' : 'studentId', protoName: 'studentId', subBuilder: StudentId.create)
    ..aOS(4, _omitFieldNames ? '' : 'ballotBox', protoName: 'ballotBox')
    ..aOS(5, _omitFieldNames ? '' : 'faculity')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Voter clone() => Voter()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Voter copyWith(void Function(Voter) updates) => super.copyWith((message) => updates(message as Voter)) as Voter;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Voter create() => Voter._();
  Voter createEmptyInstance() => create();
  static $pb.PbList<Voter> createRepeated() => $pb.PbList<Voter>();
  @$core.pragma('dart2js:noInline')
  static Voter getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Voter>(create);
  static Voter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get firstname => $_getSZ(0);
  @$pb.TagNumber(1)
  set firstname($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFirstname() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstname() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastname => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastname($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLastname() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastname() => clearField(2);

  @$pb.TagNumber(3)
  StudentId get studentId => $_getN(2);
  @$pb.TagNumber(3)
  set studentId(StudentId v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStudentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearStudentId() => clearField(3);
  @$pb.TagNumber(3)
  StudentId ensureStudentId() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get ballotBox => $_getSZ(3);
  @$pb.TagNumber(4)
  set ballotBox($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBallotBox() => $_has(3);
  @$pb.TagNumber(4)
  void clearBallotBox() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get faculity => $_getSZ(4);
  @$pb.TagNumber(5)
  set faculity($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFaculity() => $_has(4);
  @$pb.TagNumber(5)
  void clearFaculity() => clearField(5);

  /// 0 => not voted
  /// 1 => got ballot
  /// 2 => voted
  @$pb.TagNumber(6)
  $core.int get status => $_getIZ(5);
  @$pb.TagNumber(6)
  set status($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);
}

class VotingDayStats extends $pb.GeneratedMessage {
  factory VotingDayStats({
    $fixnum.Int64? totalVotes,
    $fixnum.Int64? morningVotes,
    $fixnum.Int64? afternoonVotes,
  }) {
    final $result = create();
    if (totalVotes != null) {
      $result.totalVotes = totalVotes;
    }
    if (morningVotes != null) {
      $result.morningVotes = morningVotes;
    }
    if (afternoonVotes != null) {
      $result.afternoonVotes = afternoonVotes;
    }
    return $result;
  }
  VotingDayStats._() : super();
  factory VotingDayStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VotingDayStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VotingDayStats', package: const $pb.PackageName(_omitMessageNames ? '' : 'CampusVote'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'totalVotes', protoName: 'totalVotes')
    ..aInt64(2, _omitFieldNames ? '' : 'morningVotes', protoName: 'morningVotes')
    ..aInt64(3, _omitFieldNames ? '' : 'afternoonVotes', protoName: 'afternoonVotes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VotingDayStats clone() => VotingDayStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VotingDayStats copyWith(void Function(VotingDayStats) updates) => super.copyWith((message) => updates(message as VotingDayStats)) as VotingDayStats;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VotingDayStats create() => VotingDayStats._();
  VotingDayStats createEmptyInstance() => create();
  static $pb.PbList<VotingDayStats> createRepeated() => $pb.PbList<VotingDayStats>();
  @$core.pragma('dart2js:noInline')
  static VotingDayStats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VotingDayStats>(create);
  static VotingDayStats? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalVotes => $_getI64(0);
  @$pb.TagNumber(1)
  set totalVotes($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalVotes() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalVotes() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get morningVotes => $_getI64(1);
  @$pb.TagNumber(2)
  set morningVotes($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMorningVotes() => $_has(1);
  @$pb.TagNumber(2)
  void clearMorningVotes() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get afternoonVotes => $_getI64(2);
  @$pb.TagNumber(3)
  set afternoonVotes($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAfternoonVotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfternoonVotes() => clearField(3);
}

class BallotBoxStats extends $pb.GeneratedMessage {
  factory BallotBoxStats({
    $core.String? name,
    $fixnum.Int64? totalVotes,
    $core.Iterable<VotingDayStats>? votesPerDay,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (totalVotes != null) {
      $result.totalVotes = totalVotes;
    }
    if (votesPerDay != null) {
      $result.votesPerDay.addAll(votesPerDay);
    }
    return $result;
  }
  BallotBoxStats._() : super();
  factory BallotBoxStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BallotBoxStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BallotBoxStats', package: const $pb.PackageName(_omitMessageNames ? '' : 'CampusVote'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aInt64(2, _omitFieldNames ? '' : 'totalVotes', protoName: 'totalVotes')
    ..pc<VotingDayStats>(3, _omitFieldNames ? '' : 'votesPerDay', $pb.PbFieldType.PM, protoName: 'votesPerDay', subBuilder: VotingDayStats.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BallotBoxStats clone() => BallotBoxStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BallotBoxStats copyWith(void Function(BallotBoxStats) updates) => super.copyWith((message) => updates(message as BallotBoxStats)) as BallotBoxStats;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BallotBoxStats create() => BallotBoxStats._();
  BallotBoxStats createEmptyInstance() => create();
  static $pb.PbList<BallotBoxStats> createRepeated() => $pb.PbList<BallotBoxStats>();
  @$core.pragma('dart2js:noInline')
  static BallotBoxStats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BallotBoxStats>(create);
  static BallotBoxStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalVotes => $_getI64(1);
  @$pb.TagNumber(2)
  set totalVotes($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalVotes() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalVotes() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<VotingDayStats> get votesPerDay => $_getList(2);
}

class ElectionStats extends $pb.GeneratedMessage {
  factory ElectionStats({
    $core.int? electionYear,
    $fixnum.Int64? totalVotes,
    $core.Iterable<BallotBoxStats>? ballotBoxes,
  }) {
    final $result = create();
    if (electionYear != null) {
      $result.electionYear = electionYear;
    }
    if (totalVotes != null) {
      $result.totalVotes = totalVotes;
    }
    if (ballotBoxes != null) {
      $result.ballotBoxes.addAll(ballotBoxes);
    }
    return $result;
  }
  ElectionStats._() : super();
  factory ElectionStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ElectionStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ElectionStats', package: const $pb.PackageName(_omitMessageNames ? '' : 'CampusVote'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'electionYear', $pb.PbFieldType.O3, protoName: 'electionYear')
    ..aInt64(2, _omitFieldNames ? '' : 'totalVotes', protoName: 'totalVotes')
    ..pc<BallotBoxStats>(3, _omitFieldNames ? '' : 'ballotBoxes', $pb.PbFieldType.PM, protoName: 'ballotBoxes', subBuilder: BallotBoxStats.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ElectionStats clone() => ElectionStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ElectionStats copyWith(void Function(ElectionStats) updates) => super.copyWith((message) => updates(message as ElectionStats)) as ElectionStats;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ElectionStats create() => ElectionStats._();
  ElectionStats createEmptyInstance() => create();
  static $pb.PbList<ElectionStats> createRepeated() => $pb.PbList<ElectionStats>();
  @$core.pragma('dart2js:noInline')
  static ElectionStats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ElectionStats>(create);
  static ElectionStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get electionYear => $_getIZ(0);
  @$pb.TagNumber(1)
  set electionYear($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasElectionYear() => $_has(0);
  @$pb.TagNumber(1)
  void clearElectionYear() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalVotes => $_getI64(1);
  @$pb.TagNumber(2)
  set totalVotes($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalVotes() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalVotes() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<BallotBoxStats> get ballotBoxes => $_getList(2);
}

class VoteReq extends $pb.GeneratedMessage {
  factory VoteReq({
    StudentId? studentId,
    $core.bool? isAfternoon,
  }) {
    final $result = create();
    if (studentId != null) {
      $result.studentId = studentId;
    }
    if (isAfternoon != null) {
      $result.isAfternoon = isAfternoon;
    }
    return $result;
  }
  VoteReq._() : super();
  factory VoteReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VoteReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VoteReq', package: const $pb.PackageName(_omitMessageNames ? '' : 'CampusVote'), createEmptyInstance: create)
    ..aOM<StudentId>(1, _omitFieldNames ? '' : 'studentId', protoName: 'studentId', subBuilder: StudentId.create)
    ..aOB(2, _omitFieldNames ? '' : 'isAfternoon', protoName: 'isAfternoon')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VoteReq clone() => VoteReq()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VoteReq copyWith(void Function(VoteReq) updates) => super.copyWith((message) => updates(message as VoteReq)) as VoteReq;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoteReq create() => VoteReq._();
  VoteReq createEmptyInstance() => create();
  static $pb.PbList<VoteReq> createRepeated() => $pb.PbList<VoteReq>();
  @$core.pragma('dart2js:noInline')
  static VoteReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoteReq>(create);
  static VoteReq? _defaultInstance;

  @$pb.TagNumber(1)
  StudentId get studentId => $_getN(0);
  @$pb.TagNumber(1)
  set studentId(StudentId v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStudentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStudentId() => clearField(1);
  @$pb.TagNumber(1)
  StudentId ensureStudentId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isAfternoon => $_getBF(1);
  @$pb.TagNumber(2)
  set isAfternoon($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsAfternoon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsAfternoon() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
