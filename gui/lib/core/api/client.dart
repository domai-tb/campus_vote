import 'dart:io';
import 'dart:typed_data';

import 'package:campus_vote/core/api/generated/api.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';

class CampusVoteAPIClient {
  late CampusVoteClient client;

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

    client = CampusVoteClient(channel);
  }

  Future<String> countVote(String studentId) async {
    final status = await client.setVoterAsVoted(StudentId(num: parseLongInt(studentId)));
    return status.msg;
  }

  Future<ElectionStats> getElectionStats() async {
    return await client.getElectionStats(Void());
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
