//
//  Generated code. Do not modify.
//  source: vote.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

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
    {'1': 'studentId', '3': 3, '4': 1, '5': 11, '6': '.CampusVote.StudentId', '10': 'studentId'},
    {'1': 'ballotBox', '3': 4, '4': 1, '5': 9, '10': 'ballotBox'},
    {'1': 'faculity', '3': 5, '4': 1, '5': 9, '10': 'faculity'},
  ],
};

/// Descriptor for `Voter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voterDescriptor = $convert.base64Decode(
    'CgVWb3RlchIcCglmaXJzdG5hbWUYASABKAlSCWZpcnN0bmFtZRIaCghsYXN0bmFtZRgCIAEoCV'
    'IIbGFzdG5hbWUSMwoJc3R1ZGVudElkGAMgASgLMhUuQ2FtcHVzVm90ZS5TdHVkZW50SWRSCXN0'
    'dWRlbnRJZBIcCgliYWxsb3RCb3gYBCABKAlSCWJhbGxvdEJveBIaCghmYWN1bGl0eRgFIAEoCV'
    'IIZmFjdWxpdHk=');

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
    {'1': 'votesPerDay', '3': 3, '4': 3, '5': 11, '6': '.CampusVote.VotingDayStats', '10': 'votesPerDay'},
  ],
};

/// Descriptor for `BallotBoxStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ballotBoxStatsDescriptor = $convert.base64Decode(
    'Cg5CYWxsb3RCb3hTdGF0cxISCgRuYW1lGAEgASgJUgRuYW1lEh4KCnRvdGFsVm90ZXMYAiABKA'
    'NSCnRvdGFsVm90ZXMSPAoLdm90ZXNQZXJEYXkYAyADKAsyGi5DYW1wdXNWb3RlLlZvdGluZ0Rh'
    'eVN0YXRzUgt2b3Rlc1BlckRheQ==');

@$core.Deprecated('Use electionStatsDescriptor instead')
const ElectionStats$json = {
  '1': 'ElectionStats',
  '2': [
    {'1': 'electionYear', '3': 1, '4': 1, '5': 5, '10': 'electionYear'},
    {'1': 'totalVotes', '3': 2, '4': 1, '5': 3, '10': 'totalVotes'},
    {'1': 'ballotBoxes', '3': 3, '4': 3, '5': 11, '6': '.CampusVote.BallotBoxStats', '10': 'ballotBoxes'},
  ],
};

/// Descriptor for `ElectionStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List electionStatsDescriptor = $convert.base64Decode(
    'Cg1FbGVjdGlvblN0YXRzEiIKDGVsZWN0aW9uWWVhchgBIAEoBVIMZWxlY3Rpb25ZZWFyEh4KCn'
    'RvdGFsVm90ZXMYAiABKANSCnRvdGFsVm90ZXMSPAoLYmFsbG90Qm94ZXMYAyADKAsyGi5DYW1w'
    'dXNWb3RlLkJhbGxvdEJveFN0YXRzUgtiYWxsb3RCb3hlcw==');

@$core.Deprecated('Use voteReqDescriptor instead')
const VoteReq$json = {
  '1': 'VoteReq',
  '2': [
    {'1': 'studentId', '3': 1, '4': 1, '5': 11, '6': '.CampusVote.StudentId', '10': 'studentId'},
    {'1': 'isAfternoon', '3': 2, '4': 1, '5': 8, '10': 'isAfternoon'},
  ],
};

/// Descriptor for `VoteReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voteReqDescriptor = $convert.base64Decode(
    'CgdWb3RlUmVxEjMKCXN0dWRlbnRJZBgBIAEoCzIVLkNhbXB1c1ZvdGUuU3R1ZGVudElkUglzdH'
    'VkZW50SWQSIAoLaXNBZnRlcm5vb24YAiABKAhSC2lzQWZ0ZXJub29u');

