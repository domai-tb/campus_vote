import 'dart:async';
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

    final cockroachCerts = await getCockroachCertsDir();
    final apiCerts = await getAPICertsDir();

    unawaited(
      // Restarts the API if child process dies for some reason
      Isolate.run(() async {
        while (true) {
          // Start the campusvote api.
          await Process.run(
            campusVoteBin,
            [
              'start',
              '-b=$ballotboxFlag',
              '-c=${path.join(cockroachCerts, 'client.$username.crt')}',
              '-k=${path.join(cockroachCerts, 'client.$username.key')}',
              '-a=$host',
              '-p=26258',
              '-r=${path.join(cockroachCerts, 'ca.crt')}',
              '-u=$username',
              '-m=${path.join(apiCerts, 'api-ca.crt')}',
              '-s=${path.join(apiCerts, 'api-server.crt')}',
              '-o=${path.join(apiCerts, 'api-server.key')}',
            ],
          );
        }
      }),
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
    final sqlAddr = boxSelf != null ? '${boxSelf.ipAddr}:26258' : '${setupDate.committeeIpAddr}:26258';

    final cockraochCertsDir = await getCockroachCertsDir();
    final cockroachNodeDir = await getCockroachNodeDir();

    unawaited(
      // Restarts the API if child process dies for some reason
      Isolate.run(() async {
        while (true) {
          // Start the cockroach node.
          await Process.run(
            cockroachBin,
            [
              'start',
              '--certs-dir=$cockraochCertsDir',
              '--store=$cockroachNodeDir',
              '--listen-addr=$listenAddr',
              '--sql-addr=$sqlAddr',
              '--cluster-name=stupa-bochum',
              '--join=$ballotboxJoins',
              '--advertise-addr=$listenAddr',
              '--advertise-sql-addr=$sqlAddr',
              '--background',
            ],
          );
        }
      }),
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

      if (initCluster.exitCode == 0) {
        await storage.write(
          key: STORAGEKEY_INITIALIZED_COCKROACH_NODE,
          value: 'true',
        );
      } else {
        // Cluster initialisation failed, so retry
        unawaited(startCockroachNode(setupDate, boxSelf));
        return;
      }
    }

    await Isolate.run(() {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      awaitCockRoachNode(listenAddr: listenAddr);
    });
  }
}
