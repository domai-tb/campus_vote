import 'dart:io';

import 'package:campus_vote/core/crypto/crypto.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/utils/file_utils.dart';
import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetupServices {
  final String cockroachBin = getCockroachBinPath();

  final crypto = serviceLocator<Crypto>();
  final storage = serviceLocator<FlutterSecureStorage>();

  SetupServices();

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
    final appCVDir = await getAppExportDirPath();

    // Store information that this instances created the note.
    // This node will not and cannot load any ballotbox data.
    await storage.write(key: STORAGEKEY_COMMITTEE, value: true.toString());

    // Generate a CA certificate "<certs-dir>/ca.crt" and CA key "<ca-key>".
    // The certs directory is created if it does not exist.
    final createCA = await Process.run(
      cockroachBin,
      [
        'cert',
        'create-ca',
        '--certs-dir=$tmpCVDir',
        '--ca-key=$tmpCVDir${pathSep}ca.key',
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
      final boxDir = await Directory('$tmpCVDir$pathSep${box.name}$pathSep').create(recursive: true);
      final certsDir = await Directory('${boxDir.path}$pathSep$COCKRAOCH_CERTS_DIRNAME').create(recursive: true);

      // Generate a node certificate "<certs-dir>/node.crt" and key "<certs-dir>/node.key".
      final createNode = await Process.run(
        cockroachBin,
        [
          'cert',
          'create-node',
          '--certs-dir=$tmpCVDir',
          '--ca-key=$tmpCVDir${pathSep}ca.key',
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
      await File('$tmpCVDir${pathSep}node.key').rename('${certsDir.path}${pathSep}node.key');
      await File('$tmpCVDir${pathSep}node.crt').rename('${certsDir.path}${pathSep}node.crt');

      // Generate a client certificate "<certs-dir>/client.crt" and key "<certs-dir>/node.key".
      final createClient = await Process.run(
        cockroachBin,
        [
          'cert',
          'create-client',
          '--certs-dir=$tmpCVDir',
          '--ca-key=$tmpCVDir${pathSep}ca.key',
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

      // Rename client key and cert to ballotbox specific name
      await File('$tmpCVDir${pathSep}client.${box.name.toLowerCase()}.key').rename(
        '${certsDir.path}${pathSep}client.${box.name.toLowerCase()}.key',
      );
      await File('$tmpCVDir${pathSep}client.${box.name.toLowerCase()}.crt').rename(
        '${certsDir.path}${pathSep}client.${box.name.toLowerCase()}.crt',
      );

      // Store CA TLS certificate in ballot specific config directory
      await File('$tmpCVDir${pathSep}ca.crt').copy('${certsDir.path}${pathSep}ca.crt');

      // Store setup data to ballotbox specific config directory
      await saveSetupSettingsModelToFile(
        setupData,
        '${boxDir.path}settings.json',
      );
    }

    // Generate a new key if nessarry
    await crypto.getExportEncKey(overwriteKey: true);

    // Encrypt ballotbox data and export
    await crypto.zipAndEncryptDirectories(tmpCVDir, appCVDir);

    // Committe Node & Client
    final ecCertsDir = await getCockroachCertsDir();

    // Generate a node certificate "<certs-dir>/node.crt" and key "<certs-dir>/node.key".
    final createNode = await Process.run(
      cockroachBin,
      [
        'cert',
        'create-node',
        '--certs-dir=$tmpCVDir',
        '--ca-key=$tmpCVDir${pathSep}ca.key',
        '--key-size=4096',
        '--overwrite', // Certificate and key files are overwritten if they exist.
        //'--lifetime=365d' // Certificate will be valid for 10 years (default).
        setupData.committeeIpAddr,
      ],
    );
    if (createNode.exitCode != 0) {
      print('Error running executable: ${createNode.stderr}');
    } else {
      print('Output: ${createNode.stdout}');
    }

    final createClient = await Process.run(
      cockroachBin,
      [
        'cert',
        'create-client',
        '--certs-dir=$tmpCVDir',
        '--ca-key=$tmpCVDir${pathSep}ca.key',
        '--key-size=4096',
        '--overwrite', // Certificate and key files are overwritten if they exist.
        //'--lifetime=365d' // Certificate will be valid for 10 years (default).
        'root',
      ],
    );
    if (createClient.exitCode != 0) {
      print('Error running executable: ${createClient.stderr}');
    } else {
      print('Output: ${createClient.stdout}');
    }

    // Rename Node key and cert to commiittee specific name
    await File('$tmpCVDir${pathSep}node.key').copy('$ecCertsDir${pathSep}node.key');
    await File('$tmpCVDir${pathSep}node.crt').copy('$ecCertsDir${pathSep}node.crt');
    await File('$tmpCVDir${pathSep}client.root.key').copy('$ecCertsDir${pathSep}client.root.key');
    await File('$tmpCVDir${pathSep}client.root.crt').copy('$ecCertsDir${pathSep}client.root.crt');

    await File('$tmpCVDir${pathSep}ca.crt').copy('$ecCertsDir${pathSep}ca.crt');

    await saveSetupSettingsModelToFile(setupData, '${await getCVDataDir()}${pathSep}settings.json');

    // Encrypt ballotbox data and export
    await crypto.zipAndEncryptDirectories(
      await getAppDirPath(),
      await getAppDirPath(),
    );
    File('${await getCVDataDir()}.zip.enc').renameSync(await getCommitteeDataFilePath());

    // Delete temporary directory
    Directory(tmpCVDir).deleteSync(recursive: true);
  }

  /// Get the ballot box by matching configured boxes
  /// with available network interfaces. If no interface matchs the
  /// configured data it will throw an exception (because it isn't a ballotbox).
  Future<BallotBoxSetupModel> getBallotBoxSelf(
    SetupSettingsModel setupData,
  ) async {
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

  /// Load ballotbox configuration from encrypted config file.
  /// The config files are generated on initially creation of
  /// election setup by the election committee.
  Future<SetupSettingsModel> loadBallotBox(
    String filePath,
    String boxDataPassword,
  ) async {
    final appCVDir = await getAppDirPath();
    final bbDir = await getCVDataDir();
    final ballotboxFile = await getBallotBoxDataFilePath();

    // Store decryption password
    await crypto.storeExportEncKey(boxDataPassword);

    // Copy encrypted file to application dir
    if (filePath != ballotboxFile) {
      await File(ballotboxFile).writeAsBytes(
        await File(filePath).readAsBytes(),
      );
    }

    // Encrypt ballotbox data
    final bbPath = await crypto.decryptAndUnzipFile(ballotboxFile, appCVDir);

    // Rename output directory to "ballotbox"
    try {
      Directory(bbPath).renameSync(bbDir);
    } catch (e) {
      // Directory.rename will throw an excpetion on
      // non empty directory at deletion time. Do it manually.
      Directory(bbPath).deleteSync(recursive: true);
    }

    // Set file permissions for keys correctly
    await changeAllFilePermissions(await getAppDirPath(), '600');

    final setupData = await loadSetupSettingsModelFromFile('$bbDir${pathSep}settings.json');

    return setupData;
  }

  /// Return [SetupSettingsModel] from encrypted storage.
  Future<SetupSettingsModel> loadCommittee() async {
    final appCVDir = await getAppDirPath();
    final ecDir = await getCVDataDir();
    final ecFile = await getCommitteeDataFilePath();

    // Decrypt ballotbox data
    await crypto.decryptAndUnzipFile(ecFile, appCVDir);

    // Set file permissions for keys correctly
    await changeAllFilePermissions(await getAppDirPath(), '600');

    final setupData = await loadSetupSettingsModelFromFile('$ecDir${pathSep}settings.json');

    return setupData;
  }
}
