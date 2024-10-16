import 'dart:io';
import 'dart:typed_data';

import 'package:campus_vote/core/api/generated/chat.pbgrpc.dart';
import 'package:campus_vote/core/api/generated/common.pb.dart' as common;
import 'package:campus_vote/core/api/generated/vote.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';

class CampusVoteAPIClient {
  late VoteClient voteClient;
  late ChatClient chatClient;

  final String rootCert;
  final String clientCert;
  final String clientKey;

  CampusVoteAPIClient({
    required this.rootCert,
    required this.clientCert,
    required this.clientKey,
  }) {
    final channel = ClientChannel(
      '127.0.0.1',
      port: 21797,
      options: ChannelOptions(
        credentials: CVAPIChannelCredentials(
          trustedRoots: File(rootCert).readAsBytesSync(),
          certificateChain: File(clientCert).readAsBytesSync(),
          privateKey: File(clientKey).readAsBytesSync(),
          authority: '127.0.0.1',
        ),
      ),
    );

    voteClient = VoteClient(channel);
    chatClient = ChatClient(channel);
  }

  Future<String> votingStep(String studentId, {bool? isAfternoon = false}) async {
    final status = await voteClient.registerVotingStep(
      VoteReq(
        studentId: StudentId(num: parseLongInt(studentId)),
        isAfternoon: isAfternoon,
      ),
    );
    return status.msg;
  }

  Future<ElectionStats> getElectionStats() async {
    return await voteClient.getElectionStats(common.Void());
  }

  Future<common.StatusCode> sendChatMessage(String message) async {
    return await chatClient.sendChatMessage(
      ChatMessage(message: message), // sender and timestamp is sent in backend
    );
  }

  Future<ChatHistory> getChatHistory() async {
    return await chatClient.readChatHistory(common.Void());
  }

  Future<Voter> getVoterByStudentID(String studentId) async {
    return await voteClient.getVoterByStudentId(StudentId(num: parseLongInt(studentId)));
  }

  Future<common.StatusCode> createVoter(Voter voter) async {
    return await voteClient.createVoter(voter);
  }
}

class CVAPIChannelCredentials extends ChannelCredentials {
  final Uint8List trustedRoots;
  final Uint8List certificateChain;
  final Uint8List privateKey;

  CVAPIChannelCredentials({
    required this.trustedRoots,
    required this.certificateChain,
    required this.privateKey,
    super.authority,
    super.onBadCertificate,
  }) : super.secure(certificates: trustedRoots);

  @override
  SecurityContext get securityContext {
    final ctx = super.securityContext;

    ctx!.useCertificateChainBytes(certificateChain);
    ctx.usePrivateKeyBytes(privateKey);
    ctx.setAlpnProtocols(supportedAlpnProtocols, false);
    ctx.setTrustedCertificatesBytes(trustedRoots);

    return ctx;
  }
}
