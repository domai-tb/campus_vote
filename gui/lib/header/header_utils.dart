import 'dart:io';

import 'package:campus_vote/core/utils/path_utils.dart';

/// The election committee has to initialize the cockroach database on
/// first startup.
const STORAGEKEY_INITIALIZED_COCKROACH_NODE = 'clusterIsInitialized';

/// This is Flutter Secure Strage's identifier for the database encryption
/// password. All data will be encrypted inside CockroachDB with this password.
const STORAGEKEY_DATABASE_ENCRYPTION_KEY = 'database_encryption_key';

const FORMKEY_ENCRYPTION_PASSWORD = 'startForm_encPassword';

/// Executes the cockroach node status command with retries on failure.
/// The status command return non-zero return values if node isn't ready yet.
/// - [retries]: The number of retries on failure.
/// - [delaySeconds]: The delay between retries in seconds.
Future<void> awaitCockRoachNode({
  required String listenAddr,
  int retries = 3,
  int delaySeconds = 2,
}) async {
  int attempts = 0;

  final String cockroachBin = getCockroachBinPath();

  while (attempts < retries) {
    attempts++;

    final result = Process.runSync(
      cockroachBin,
      [
        'node',
        'status',
        '--certs-dir=${await getCockroachCertsDir()}',
        '--host=$listenAddr',
      ],
    );

    if (result.exitCode == 0) {
      return;
    }

    if (attempts < retries) {
      // Wait before retrying
      await Future.delayed(Duration(seconds: delaySeconds));
    }
  }

  // Throw error after exceeding maximum retries
  throw Exception('Failed to execute command after $retries attempts.');
}
