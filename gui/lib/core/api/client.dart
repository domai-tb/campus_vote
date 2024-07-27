import 'dart:io';
import 'dart:typed_data';

import 'package:campus_vote/core/api/generated/api.pbgrpc.dart';
import 'package:grpc/grpc.dart';

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

  Future<ElectionStats> getElectionStats() async {
    return await client.getElectionStats(Void());
  }
}

class CVAPIChannelCredentials extends ChannelCredentials {
  final Uint8List? certificateChain;
  final Uint8List? privateKey;

  CVAPIChannelCredentials({
    Uint8List? trustedRoots,
    this.certificateChain,
    this.privateKey,
    super.authority,
    super.onBadCertificate,
  }) : super.secure(certificates: trustedRoots);

  @override
  SecurityContext get securityContext {
    final ctx = super.securityContext;
    if (certificateChain != null) {
      ctx!.useCertificateChainBytes(certificateChain!);
    }
    if (privateKey != null) {
      ctx!.usePrivateKeyBytes(privateKey!);
    }

    return ctx!;
  }
}
