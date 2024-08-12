// ignore: non_constant_identifier_names
import 'dart:io';

import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

String pathSep = Platform.pathSeparator;

/// Get path to a campusvote application directory.
Future<String> getAppDirPath() async {
  final appDir = await getApplicationCacheDirectory();
  final appCVDir = '${appDir.path}$pathSep';

  // Ensure the app dir exists
  // ignore: avoid_slow_async_io
  if (!await Directory(appCVDir).exists()) {
    await Directory(appCVDir).create(recursive: true);
  }

  return appCVDir;
}

/// Get path to a campusvote application directory.
Future<String> getAppExportDirPath() async {
  final appDir = await getApplicationDocumentsDirectory();
  final appCVDir = '${appDir.path}${pathSep}campus_vote';

  // Ensure the app dir exists
  // ignore: avoid_slow_async_io
  if (!await Directory(appCVDir).exists()) {
    await Directory(appCVDir).create(recursive: true);
  }

  return appCVDir;
}

/// Get path to encrypted ballot box data file.
Future<String> getBallotBoxDataFilePath() async {
  final appCVDir = await getAppDirPath();
  return '${appCVDir}campusvote.bb';
}

/// Get the path to CockRoach executable.
String getCampusVoteBinPath() {
  late String retVal;

  final exePath = Platform.resolvedExecutable;
  final bundlePath = exePath.substring(0, exePath.lastIndexOf(pathSep));

  if (!Platform.isWindows) {
    retVal = '$bundlePath${pathSep}bin${pathSep}campusvote';
  } else {
    retVal = '$bundlePath${pathSep}bin${pathSep}campusvote.exe';
  }

  if (File(retVal).existsSync()) {
    return retVal;
  }

  throw Exception('$retVal is not a valid file');
}

/// Get the path to CockRoach executable.
String getCockroachBinPath() {
  late String retVal;

  final exePath = Platform.resolvedExecutable;
  final bundlePath = exePath.substring(0, exePath.lastIndexOf(pathSep));

  if (!Platform.isWindows) {
    retVal = '$bundlePath${pathSep}bin${pathSep}cockroach';
  } else {
    retVal = '$bundlePath${pathSep}bin${pathSep}cockroach.exe';
  }

  if (File(retVal).existsSync()) {
    return retVal;
  }

  throw Exception('$retVal is not a valid file');
}

/// Get data directory of cockroach certs
Future<String> getCockroachCertsDir() async {
  final appCVDir = await getCVDataDir();
  final retVal = path.join(appCVDir, 'cockroach-certs');
  Directory(retVal).createSync(recursive: true);
  return retVal;
}

/// Get data directory of cockroach node
Future<String> getCockroachNodeDir() async {
  final appCVDir = await getCVDataDir();
  final nodeDir = path.join(appCVDir, 'cockroach-node');

  // Create directory if it doesn't exist
  Directory(nodeDir).createSync();

  return nodeDir;
}

/// Get path to encrypted ballot box data file.
Future<String> getCommitteeDataFilePath() async {
  final appCVDir = await getAppDirPath();
  return '${appCVDir}campusvote.ec';
}

/// Get data directory of ballotbox
Future<String> getCVDataDir() async {
  late String retVal;

  final appCVDir = await getAppDirPath();
  final setupServices = serviceLocator<SetupServices>();

  if (await setupServices.isElectionCommittee()) {
    retVal = path.join(appCVDir, '.committee');
  } else {
    retVal = path.join(appCVDir, '.ballotbox');
  }

  Directory(retVal).createSync(recursive: true);
  return retVal;
}

/// Get a random temp directory.
Future<String> getTempDirPath() async {
  // use encryption key as random identifier
  final tmpId = encrypt.Key.fromLength(16).base16;

  // Store temporary files into a random tmp directory
  final tmpDir = await getTemporaryDirectory();
  final tmpCVDir = '${tmpDir.path}$pathSep.$tmpId';

  // Ensure the temp dir exists
  // ignore: avoid_slow_async_io
  if (!await Directory(tmpCVDir).exists()) {
    await Directory(tmpCVDir).create(recursive: true);
  }

  return tmpCVDir;
}
