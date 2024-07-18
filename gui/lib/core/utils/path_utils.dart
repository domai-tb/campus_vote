// ignore: non_constant_identifier_names
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

String pathSep = Platform.pathSeparator;

/// Get a random temp directory.
Future<String> getTempDirPath() async {
  // use encryption key as random identifier
  final tmpId = encrypt.Key.fromLength(32).base16;

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

/// Get path to encrypted ballot box data file.
Future<String> getBallotBoxDataFilePath() async {
  final appCVDir = await getAppDirPath();
  return '${appCVDir}campusvote.bb';
}

/// Get path to encrypted ballot box data file.
Future<String> getCommitteeDataFilePath() async {
  final appCVDir = await getAppDirPath();
  return '${appCVDir}campusvote.ec';
}
