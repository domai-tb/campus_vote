import 'dart:io';
import 'package:campus_vote/core/crypto/crypto.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetupServices {
  late String _COCKROACH_BIN;

  final crypto = serviceLocator<Crypto>();
  final storage = serviceLocator<FlutterSecureStorage>();

  SetupServices() {
    final exePath = Platform.resolvedExecutable;
    final bundlePath = exePath.substring(0, exePath.lastIndexOf(PATHSEP));

    if (!Platform.isWindows) {
      _COCKROACH_BIN = '$bundlePath${PATHSEP}bin${PATHSEP}cockroach';
    } else {
      _COCKROACH_BIN = '$bundlePath${PATHSEP}bin${PATHSEP}cockroach.exe';
    }
  }

  /// Creates the election data that is required to use CockRoachDB.
  ///
  /// That includes:
  ///   1. Generation of an CA TLS Keypair
  ///   2. Generation of TLS Keypairs for each ballotbox CockRoachDB node
  ///   3. Generation of TLS Keypairs for each ballotbox CockRoachDB client
  ///
  /// After generating all TLS Keypairs the setup config directory of each
  /// ballotbox will be zipped and encrypted. The encrypted ZIP-file can
  /// be imported to setup a ballotbox.
  Future<void> createElection(SetupSettingsModel setupData) async {
    final tmpCVDir = await getTempDirPath();
    final appCVDir = await getAppDirPath();

    // Store information that this instances created the note.
    // This node will not and cannot load any ballotbox data.
    await storage.write(key: STORAGEKEY_COMMITTEE, value: true.toString());

    // Generate a CA certificate "<certs-dir>/ca.crt" and CA key "<ca-key>".
    // The certs directory is created if it does not exist.
    final createCA = await Process.run(
      _COCKROACH_BIN,
      [
        'cert',
        'create-ca',
        '--certs-dir=$tmpCVDir',
        '--ca-key=$tmpCVDir${PATHSEP}ca.key',
        '--key-size=4096',
        '--overwrite', // Certificate and key files are overwritten if they exist.
        //'--lifetime=365d' // Certificate will be valid for 10 years (default).
      ],
    );
    if (createCA.exitCode != 0) {
      print('Error running executable: ${createCA.stderr}');
    } else {
      print('Output: ${createCA.stdout}');
    }

    for (final box in setupData.ballotBoxes) {
      // Create ballotbox specific tmp dir
      final boxDir = await Directory('$tmpCVDir$PATHSEP${box.name}')
          .create(recursive: true);

      // Generate a node certificate "<certs-dir>/node.crt" and key "<certs-dir>/node.key".
      final createNode = await Process.run(
        _COCKROACH_BIN,
        [
          'cert',
          'create-node',
          '--certs-dir=$tmpCVDir',
          '--ca-key=$tmpCVDir${PATHSEP}ca.key',
          '--key-size=4096',
          '--overwrite', // Certificate and key files are overwritten if they exist.
          //'--lifetime=365d' // Certificate will be valid for 10 years (default).
          box.ipAddr,
        ],
      );

      if (createNode.exitCode != 0) {
        print('Error running executable: ${createNode.stderr}');
      } else {
        print('Output: ${createNode.stdout}');
      }

      // Rename Node key and cert to ballotbox specific name
      await File('$tmpCVDir${PATHSEP}node.key').rename(
        '${boxDir.path}${PATHSEP}node.${box.name.toLowerCase()}.key',
      );
      await File('$tmpCVDir${PATHSEP}node.crt').rename(
        '${boxDir.path}${PATHSEP}node.${box.name.toLowerCase()}.crt',
      );

      // Generate a client certificate "<certs-dir>/client.crt" and key "<certs-dir>/node.key".
      final createClient = await Process.run(
        _COCKROACH_BIN,
        [
          'cert',
          'create-client',
          '--certs-dir=$tmpCVDir',
          '--ca-key=$tmpCVDir${PATHSEP}ca.key',
          '--key-size=4096',
          '--overwrite', // Certificate and key files are overwritten if they exist.
          //'--lifetime=365d' // Certificate will be valid for 10 years (default).
          box.name,
        ],
      );

      if (createClient.exitCode != 0) {
        print('Error running executable: ${createClient.stderr}');
      } else {
        print('Output: ${createClient.stdout}');
      }

      // Rename Node key and cert to ballotbox specific name
      await File('$tmpCVDir${PATHSEP}client.${box.name.toLowerCase()}.key')
          .rename(
        '${boxDir.path}${PATHSEP}client.${box.name.toLowerCase()}.key',
      );
      await File('$tmpCVDir${PATHSEP}client.${box.name.toLowerCase()}.crt')
          .rename(
        '${boxDir.path}${PATHSEP}client.${box.name.toLowerCase()}.crt',
      );

      // Store setup data to ballotbox specific config directory
      await saveSetupSettingsModelToFile(
        setupData,
        '${boxDir.path}${PATHSEP}settings.json',
      );
    }

    // Encrypt ballotbox data and export
    await crypto.zipAndEncryptDirectories(tmpCVDir, appCVDir);

    // Store and encrypt setup data config directory
    final settingsPath = '$tmpCVDir${PATHSEP}settings.json';
    await saveSetupSettingsModelToFile(setupData, settingsPath);
    await crypto.encryptFile(settingsPath, await getCommitteeDataFilePath());

    // Delete temporary directory
    Directory(tmpCVDir).deleteSync(recursive: true);
  }

  /// Load ballotbox configuration from encrypted config file.
  /// The config files are generated on initially creation of
  /// election setup by the election committee.
  Future<SetupSettingsModel> loadBallotBox(
    String filePath,
    String boxDataPassword,
  ) async {
    final appCVDir = await getAppDirPath();

    // Store decryption password
    await crypto.storeExportEncKey(boxDataPassword);

    // Copy encrypted file to application dir
    if (filePath != await getBallotBoxDataFilePath()) {
      await File(await getBallotBoxDataFilePath()).writeAsBytes(
        await File(filePath).readAsBytes(),
      );
    }

    // Encrypt ballotbox data
    final bbPath = await crypto.decryptAndUnzipFile(
      await getBallotBoxDataFilePath(),
      appCVDir,
    );

    final setupData =
        await loadSetupSettingsModelFromFile('$bbPath${PATHSEP}settings.json');

    return setupData;
  }

  /// Return [SetupSettingsModel] from encrypted storage.
  Future<SetupSettingsModel> loadCommittee() async {
    final tmpFile = '${await getTempDirPath()}/settings.json';
    final ecFilePath = await getCommitteeDataFilePath();

    // decrypt and load setup settings
    await crypto.decryptFile(ecFilePath, tmpFile);
    final settings = await loadSetupSettingsModelFromFile(tmpFile);

    return settings;
  }

  /// Get the information if the this nodes created the election.
  /// If true, this node is the election committee.
  Future<bool> isElectionCommittee() async {
    final boolStr = await storage.read(key: STORAGEKEY_COMMITTEE);
    if (boolStr == null) {
      return false; // election was not created on this node
    } else {
      return bool.parse(boolStr); // in this case always true
    }
  }

  /// Get the ballot box by matching configured boxes
  /// with available network interfaces. If no interface matchs the
  /// configured data it will throw an exception (because it isn't a ballotbox).
  Future<BallotBoxSetupModel> getBallotBoxSelf(
      SetupSettingsModel setupData) async {
    if (await isElectionCommittee()) {
      throw Exception('this instances is the election commitee');
    }

    // check if any networking interface address ..
    for (final interface in await NetworkInterface.list()) {
      for (final box in setupData.ballotBoxes) {
        // ... match any IP address of ballt boxes.
        if (interface.addresses.contains(InternetAddress(box.ipAddr))) {
          return box;
        }
      }
    }

    throw Exception(
      'this instance is neither an election commitee nor a bllot box',
    );
  }
}
