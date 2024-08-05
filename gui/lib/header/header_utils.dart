import 'dart:io';

import 'package:campus_vote/core/utils/path_utils.dart';

/// The election committee has to initialize the cockroach database on
/// first startup.
const STORAGEKEY_INITIALIZED_COCKROACH_NODE = 'clusterIsInitialized';

/// Executes a command with retries on failure.
/// - [command]: The command to execute.
/// - [arguments]: The arguments for the command.
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
    try {
      final result = await Process.runSync(
        cockroachBin,
        [
          'node',
          'status',
          '--certs-dir=${await getCockroachCertsDir()}',
          '--host=$listenAddr',
        ],
      );

      if (result.exitCode == 0) {
        // Command executed successfully
        print('Command executed successfully.');
        return;
      } else {
        // Command failed, log the error
        print(
          'Command failed with exit code ${result.exitCode}: ${result.stderr}',
        );
      }
    } catch (e) {
      print('Command execution failed: $e');
    }

    if (attempts < retries) {
      // Wait before retrying
      await Future.delayed(Duration(seconds: delaySeconds));
    }
  }

  // Throw error after exceeding maximum retries
  throw Exception('Failed to execute command after $retries attempts.');
}
