//
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'Message', '3': 1, '4': 1, '5': 9, '10': 'Message'},
    {'1': 'Sender', '3': 2, '4': 1, '5': 9, '10': 'Sender'},
    {'1': 'SendAt', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'SendAt'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIYCgdNZXNzYWdlGAEgASgJUgdNZXNzYWdlEhYKBlNlbmRlchgCIAEoCV'
    'IGU2VuZGVyEjIKBlNlbmRBdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBlNl'
    'bmRBdA==');

@$core.Deprecated('Use chatHistoryDescriptor instead')
const ChatHistory$json = {
  '1': 'ChatHistory',
  '2': [
    {'1': 'Chat', '3': 1, '4': 3, '5': 11, '6': '.CampusVote.ChatMessage', '10': 'Chat'},
  ],
};

/// Descriptor for `ChatHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatHistoryDescriptor = $convert.base64Decode(
    'CgtDaGF0SGlzdG9yeRIrCgRDaGF0GAEgAygLMhcuQ2FtcHVzVm90ZS5DaGF0TWVzc2FnZVIEQ2'
    'hhdA==');

