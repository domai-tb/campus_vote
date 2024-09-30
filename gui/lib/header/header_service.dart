import 'dart:io';
import 'dart:isolate';

import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/header/header_utils.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;

class HeaderServices {
  final String cockroachBin = getCockroachBinPath();
  final String campusVoteBin = getCampusVoteBinPath();

  final storage = serviceLocator<FlutterSecureStorage>();
  final setupServices = serviceLocator<SetupServices>();

  final rootIsolateToken = RootIsolateToken.instance!; // Isolate root identifier for multi threading

  /// Starts the Campus Vote API.
  ///
  /// Will throw an error if required TLS certificates or key-pair is not readable.
  Future<void> startCampusVoteAPI(
    SetupSettingsModel setupDate, [
    BallotBoxSetupModel? boxSelf,
  ]) async {
    // ballot box names as comma seperated list
    String ballotboxFlag = '';
    for (final box in setupDate.ballotBoxes) {
      final buf = '${box.name},$ballotboxFlag';
      ballotboxFlag = buf;
    }
    // strip last comma
    ballotboxFlag = ballotboxFlag.substring(0, ballotboxFlag.length - 1);

    // ballotbox vs. committee
    final String username, host;
    if (boxSelf == null) {
      username = 'root';
      host = setupDate.committeeIpAddr;
    } else {
      username = boxSelf.name.toLowerCase();
      host = boxSelf.ipAddr;
    }

    // Start the cockroach node.
    await Process.start(
      campusVoteBin,
      [
        '-b=$ballotboxFlag',
        '-c=${path.join(await getCockroachCertsDir(), 'client.$username.crt')}',
        '-k=${path.join(await getCockroachCertsDir(), 'client.$username.key')}',
        '-a=$host',
        '-r=${path.join(await getCockroachCertsDir(), 'ca.crt')}',
        '-u=$username',
      ],
    );
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
    final listenAddr = boxSelf != null ? '${boxSelf.ipAddr}:26257' : '${setupDate.committeeIpAddr}:26257';

    final cockraochCertsDir = await getCockroachCertsDir();
    final cockroachNodeDir = await getCockroachNodeDir();

    // Start the cockroach node.
    await Process.start(
      cockroachBin,
      [
        'start',
        '--certs-dir=$cockraochCertsDir',
        '--store=$cockroachNodeDir',
        '--listen-addr=$listenAddr',
        '--cluster-name=stupa-bochum',
        '--join=$ballotboxJoins',
        '--background',
      ],
    );

    final isInitialized = await storage.read(key: STORAGEKEY_INITIALIZED_COCKROACH_NODE);
    if (isInitialized == null && await setupServices.isElectionCommittee()) {
      final initCluster = await Isolate.run(
        () async {
          BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
          return Process.runSync(
            cockroachBin,
            [
              'init',
              '--certs-dir=$cockraochCertsDir',
              '--host=$listenAddr',
              '--cluster-name=stupa-bochum',
            ],
          );
        },
      );

      if (initCluster.exitCode != 0) {
        print('Error running executable: ${initCluster.stderr}');
      } else {
        print('Output: ${initCluster.stdout}');
        await storage.write(
          key: STORAGEKEY_INITIALIZED_COCKROACH_NODE,
          value: 'true',
        );
      }

      //TODO: Create clients and SQL tables
    }

    await Isolate.run(() {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      awaitCockRoachNode(listenAddr: listenAddr);
    });
  }
}
