//
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $3;

class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.String? message,
    $core.String? sender,
    $3.Timestamp? sendAt,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    if (sender != null) {
      $result.sender = sender;
    }
    if (sendAt != null) {
      $result.sendAt = sendAt;
    }
    return $result;
  }
  ChatMessage._() : super();
  factory ChatMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'CampusVote'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'Message', protoName: 'Message')
    ..aOS(2, _omitFieldNames ? '' : 'Sender', protoName: 'Sender')
    ..aOM<$3.Timestamp>(3, _omitFieldNames ? '' : 'SendAt', protoName: 'SendAt', subBuilder: $3.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatMessage clone() => ChatMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage)) as ChatMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  ChatMessage createEmptyInstance() => create();
  static $pb.PbList<ChatMessage> createRepeated() => $pb.PbList<ChatMessage>();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $3.Timestamp get sendAt => $_getN(2);
  @$pb.TagNumber(3)
  set sendAt($3.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSendAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearSendAt() => clearField(3);
  @$pb.TagNumber(3)
  $3.Timestamp ensureSendAt() => $_ensure(2);
}

class ChatHistory extends $pb.GeneratedMessage {
  factory ChatHistory({
    $core.Iterable<ChatMessage>? chat,
  }) {
    final $result = create();
    if (chat != null) {
      $result.chat.addAll(chat);
    }
    return $result;
  }
  ChatHistory._() : super();
  factory ChatHistory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatHistory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatHistory', package: const $pb.PackageName(_omitMessageNames ? '' : 'CampusVote'), createEmptyInstance: create)
    ..pc<ChatMessage>(1, _omitFieldNames ? '' : 'Chat', $pb.PbFieldType.PM, protoName: 'Chat', subBuilder: ChatMessage.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatHistory clone() => ChatHistory()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatHistory copyWith(void Function(ChatHistory) updates) => super.copyWith((message) => updates(message as ChatHistory)) as ChatHistory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatHistory create() => ChatHistory._();
  ChatHistory createEmptyInstance() => create();
  static $pb.PbList<ChatHistory> createRepeated() => $pb.PbList<ChatHistory>();
  @$core.pragma('dart2js:noInline')
  static ChatHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatHistory>(create);
  static ChatHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ChatMessage> get chat => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
