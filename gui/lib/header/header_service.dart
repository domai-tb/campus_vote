import 'dart:io';

import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/setup/setup_models.dart';

class HeaderServices {
  final String cockroachBin = getCockroachBinPath();

  /// Starts the Cockroach node.
  ///
  /// Will throw an error if required TLS certificates or key-pair is not readable.
  Future<void> startCockroachNode(
    SetupSettingsModel setupDate,
    BallotBoxSetupModel boxSelf,
  ) async {
    // List of IP addresses all boxes join.
    // NOTE: It's okay that box joins itself.
    String ballotboxJoins = '';
    for (final box in setupDate.ballotBoxes) {
      final newJoin = '${box.ipAddr}:26257,$ballotboxJoins';
      ballotboxJoins = newJoin;
    }

    // Start the cockroach node.
    final startNode = await Process.run(
      cockroachBin,
      [
        'start',
        '--certs-dir=${await getCockroachCertsDir()}',
        '--store=${await getCockroachNodeDir()}',
        '--listen-addr=${boxSelf.ipAddr}:26257',
        '--cluster-name=stupa-bochum',
        '--join=$ballotboxJoins',
        '--background',
      ],
    );

    if (await startNode.exitCode != 0) {
      print('Error running executable: ${startNode.stderr}');
    } else {
      print('Output: ${startNode.stdout}');
    }
  }

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
}
