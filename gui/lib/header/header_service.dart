import 'dart:io';

import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/header/header_utils.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HeaderServices {
  final String cockroachBin = getCockroachBinPath();
  final storage = serviceLocator<FlutterSecureStorage>();
  final setupServices = serviceLocator<SetupServices>();

  /// Starts the Campus Vote API.
  ///
  /// Will throw an error if required TLS certificates or key-pair is not readable.
  Future<void> startCampusVoteAPI() async {
    // Start the cockroach node.
    final startAPI = await Process.run(
      '',
      [],
    );

    if (await startAPI.exitCode != 0) {
      print('Error running executable: ${startAPI.stderr}');
    } else {
      print('Output: ${startAPI.stdout}');
    }
  }

  /// Starts the Cockroach node.
  ///
  /// Will throw an error if required TLS certificates or key-pair is not readable.
  Future<void> startCockroachNode(
    SetupSettingsModel setupDate, [
    BallotBoxSetupModel? boxSelf,
  ]) async {
    // List of IP addresses all boxes join.
    // NOTE: It's okay that box joins itself.
    String ballotboxJoins = '${setupDate.committeeIpAddr}:26257';
    for (final box in setupDate.ballotBoxes) {
      final newJoin = '${box.ipAddr}:26257,$ballotboxJoins';
      ballotboxJoins = newJoin;
    }

    // boxSelf == null <=> isElectionCommittee == true
    final listenAddr = boxSelf != null
        ? '${boxSelf.ipAddr}:26257'
        : '${setupDate.committeeIpAddr}:26257';

    // Start the cockroach node.
    await Process.start(
      cockroachBin,
      [
        'start',
        '--certs-dir=${await getCockroachCertsDir()}',
        '--store=${await getCockroachNodeDir()}',
        '--listen-addr=$listenAddr',
        '--cluster-name=stupa-bochum',
        '--join=$ballotboxJoins',
        '--background',
      ],
    );

    final isInitialized =
        await storage.read(key: STORAGEKEY_INITIALIZED_COCKROACH_NODE);
    if (isInitialized == null && await setupServices.isElectionCommittee()) {
      final initCluster = await Process.run(
        cockroachBin,
        [
          'init',
          '--certs-dir=${await getCockroachCertsDir()}',
          '--host=$listenAddr',
          '--cluster-name=stupa-bochum',
        ],
      );

      if (await initCluster.exitCode != 0) {
        print('Error running executable: ${initCluster.stderr}');
      } else {
        print('Output: ${initCluster.stdout}');
      }
    }
  }
}
