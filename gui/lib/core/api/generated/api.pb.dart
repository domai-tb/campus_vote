//
//  Generated code. Do not modify.
//  source: api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Void extends $pb.GeneratedMessage {
  factory Void() => create();
  Void._() : super();
  factory Void.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Void.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Void', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Void clone() => Void()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Void copyWith(void Function(Void) updates) => super.copyWith((message) => updates(message as Void)) as Void;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Void create() => Void._();
  Void createEmptyInstance() => create();
  static $pb.PbList<Void> createRepeated() => $pb.PbList<Void>();
  @$core.pragma('dart2js:noInline')
  static Void getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Void>(create);
  static Void? _defaultInstance;
}

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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StudentId', createEmptyInstance: create)
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
    return $result;
  }
  Voter._() : super();
  factory Voter.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Voter.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Voter', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstname')
    ..aOS(2, _omitFieldNames ? '' : 'lastname')
    ..aOM<StudentId>(3, _omitFieldNames ? '' : 'studentId', protoName: 'studentId', subBuilder: StudentId.create)
    ..aOS(4, _omitFieldNames ? '' : 'ballotBox', protoName: 'ballotBox')
    ..aOS(5, _omitFieldNames ? '' : 'faculity')
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
}

class StatusCode extends $pb.GeneratedMessage {
  factory StatusCode({
    $core.int? status,
    $core.String? msg,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (msg != null) {
      $result.msg = msg;
    }
    return $result;
  }
  StatusCode._() : super();
  factory StatusCode.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StatusCode.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StatusCode', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'msg')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StatusCode clone() => StatusCode()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StatusCode copyWith(void Function(StatusCode) updates) => super.copyWith((message) => updates(message as StatusCode)) as StatusCode;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatusCode create() => StatusCode._();
  StatusCode createEmptyInstance() => create();
  static $pb.PbList<StatusCode> createRepeated() => $pb.PbList<StatusCode>();
  @$core.pragma('dart2js:noInline')
  static StatusCode getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StatusCode>(create);
  static StatusCode? _defaultInstance;

  /// -1 => something unexpected
  /// 0  => no error
  /// 1  => student allready exists
  /// 2  => student not found
  /// 3  => student allready voted
  /// 4  => ballotbox not found
  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => clearField(2);
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VotingDayStats', createEmptyInstance: create)
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BallotBoxStats', createEmptyInstance: create)
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ElectionStats', createEmptyInstance: create)
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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
