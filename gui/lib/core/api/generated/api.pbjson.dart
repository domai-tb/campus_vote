//
//  Generated code. Do not modify.
//  source: api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use voidDescriptor instead')
const Void$json = {
  '1': 'Void',
};

/// Descriptor for `Void`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voidDescriptor = $convert.base64Decode(
    'CgRWb2lk');

@$core.Deprecated('Use studentIdDescriptor instead')
const StudentId$json = {
  '1': 'StudentId',
  '2': [
    {'1': 'num', '3': 1, '4': 1, '5': 3, '10': 'num'},
  ],
};

/// Descriptor for `StudentId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List studentIdDescriptor = $convert.base64Decode(
    'CglTdHVkZW50SWQSEAoDbnVtGAEgASgDUgNudW0=');

@$core.Deprecated('Use voterDescriptor instead')
const Voter$json = {
  '1': 'Voter',
  '2': [
    {'1': 'firstname', '3': 1, '4': 1, '5': 9, '10': 'firstname'},
    {'1': 'lastname', '3': 2, '4': 1, '5': 9, '10': 'lastname'},
    {'1': 'studentId', '3': 3, '4': 1, '5': 11, '6': '.StudentId', '10': 'studentId'},
    {'1': 'ballotBox', '3': 4, '4': 1, '5': 9, '10': 'ballotBox'},
    {'1': 'faculity', '3': 5, '4': 1, '5': 9, '10': 'faculity'},
  ],
};

/// Descriptor for `Voter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voterDescriptor = $convert.base64Decode(
    'CgVWb3RlchIcCglmaXJzdG5hbWUYASABKAlSCWZpcnN0bmFtZRIaCghsYXN0bmFtZRgCIAEoCV'
    'IIbGFzdG5hbWUSKAoJc3R1ZGVudElkGAMgASgLMgouU3R1ZGVudElkUglzdHVkZW50SWQSHAoJ'
    'YmFsbG90Qm94GAQgASgJUgliYWxsb3RCb3gSGgoIZmFjdWxpdHkYBSABKAlSCGZhY3VsaXR5');

@$core.Deprecated('Use statusCodeDescriptor instead')
const StatusCode$json = {
  '1': 'StatusCode',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
    {'1': 'msg', '3': 2, '4': 1, '5': 9, '10': 'msg'},
  ],
};

/// Descriptor for `StatusCode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusCodeDescriptor = $convert.base64Decode(
    'CgpTdGF0dXNDb2RlEhYKBnN0YXR1cxgBIAEoBVIGc3RhdHVzEhAKA21zZxgCIAEoCVIDbXNn');

@$core.Deprecated('Use votingDayStatsDescriptor instead')
const VotingDayStats$json = {
  '1': 'VotingDayStats',
  '2': [
    {'1': 'totalVotes', '3': 1, '4': 1, '5': 3, '10': 'totalVotes'},
    {'1': 'morningVotes', '3': 2, '4': 1, '5': 3, '10': 'morningVotes'},
    {'1': 'afternoonVotes', '3': 3, '4': 1, '5': 3, '10': 'afternoonVotes'},
  ],
};

/// Descriptor for `VotingDayStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List votingDayStatsDescriptor = $convert.base64Decode(
    'Cg5Wb3RpbmdEYXlTdGF0cxIeCgp0b3RhbFZvdGVzGAEgASgDUgp0b3RhbFZvdGVzEiIKDG1vcm'
    '5pbmdWb3RlcxgCIAEoA1IMbW9ybmluZ1ZvdGVzEiYKDmFmdGVybm9vblZvdGVzGAMgASgDUg5h'
    'ZnRlcm5vb25Wb3Rlcw==');

@$core.Deprecated('Use ballotBoxStatsDescriptor instead')
const BallotBoxStats$json = {
  '1': 'BallotBoxStats',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'totalVotes', '3': 2, '4': 1, '5': 3, '10': 'totalVotes'},
    {'1': 'votesPerDay', '3': 3, '4': 3, '5': 11, '6': '.VotingDayStats', '10': 'votesPerDay'},
  ],
};

/// Descriptor for `BallotBoxStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ballotBoxStatsDescriptor = $convert.base64Decode(
    'Cg5CYWxsb3RCb3hTdGF0cxISCgRuYW1lGAEgASgJUgRuYW1lEh4KCnRvdGFsVm90ZXMYAiABKA'
    'NSCnRvdGFsVm90ZXMSMQoLdm90ZXNQZXJEYXkYAyADKAsyDy5Wb3RpbmdEYXlTdGF0c1ILdm90'
    'ZXNQZXJEYXk=');

@$core.Deprecated('Use electionStatsDescriptor instead')
const ElectionStats$json = {
  '1': 'ElectionStats',
  '2': [
    {'1': 'electionYear', '3': 1, '4': 1, '5': 5, '10': 'electionYear'},
    {'1': 'totalVotes', '3': 2, '4': 1, '5': 3, '10': 'totalVotes'},
    {'1': 'ballotBoxes', '3': 3, '4': 3, '5': 11, '6': '.BallotBoxStats', '10': 'ballotBoxes'},
  ],
};

/// Descriptor for `ElectionStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List electionStatsDescriptor = $convert.base64Decode(
    'Cg1FbGVjdGlvblN0YXRzEiIKDGVsZWN0aW9uWWVhchgBIAEoBVIMZWxlY3Rpb25ZZWFyEh4KCn'
    'RvdGFsVm90ZXMYAiABKANSCnRvdGFsVm90ZXMSMQoLYmFsbG90Qm94ZXMYAyADKAsyDy5CYWxs'
    'b3RCb3hTdGF0c1ILYmFsbG90Qm94ZXM=');

