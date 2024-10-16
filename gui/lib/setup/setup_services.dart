import 'dart:io';
import 'dart:isolate';

import 'package:campus_vote/core/crypto/crypto.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/utils/file_utils.dart';
import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetupServices {
  final String cockroachBin = getCockroachBinPath();
  final String campusvoteBin = getCampusVoteBinPath();

  final crypto = serviceLocator<Crypto>();
  final storage = serviceLocator<FlutterSecureStorage>();

  final rootIsolateToken = RootIsolateToken.instance!; // Isolate root identifier for multi threading

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
    await Isolate.run(() {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      return Process.runSync(
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
    });

    // Will be committee because this function is only called in the
    // setup process. Only committee setups new elections.
    final committeCertsDir = await getAPICertsDir();

    await Isolate.run(() async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

      // ballot box names as comma seperated list
      String ballotboxFlag = '';
      for (final box in setupData.ballotBoxes) {
        final buf = '${box.name},$ballotboxFlag';
        ballotboxFlag = buf;
      }
      // strip last comma
      ballotboxFlag = ballotboxFlag.substring(0, ballotboxFlag.length - 1);

      await Process.run(
        campusvoteBin,
        [
          'gen',
          'tls',
          '-b=$ballotboxFlag',
          '-d=$tmpCVDir',
          '-c=$committeCertsDir',
        ],
      );
    });

    final futureList = <Future>[];
    for (final box in setupData.ballotBoxes) {
      // Create ballotbox specific tmp dir
      final boxDir = await Directory('$tmpCVDir$pathSep${box.name}$pathSep').create(recursive: true);
      final certsDir = await Directory('${boxDir.path}$pathSep$COCKRAOCH_CERTS_DIRNAME').create(recursive: true);

      // Generate a node certificate "<certs-dir>/node.crt" and key "<certs-dir>/node.key".
      final bbIsolate = Isolate.run(() async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

        // Store CA TLS certificate in ballot specific config directory
        await File('$tmpCVDir${pathSep}ca.crt').copy('${certsDir.path}${pathSep}ca.crt');

        Process.runSync(
          cockroachBin,
          [
            'cert',
            'create-node',
            '--certs-dir=${certsDir.path}',
            '--ca-key=$tmpCVDir${pathSep}ca.key',
            '--key-size=4096',
            '--overwrite', // Certificate and key files are overwritten if they exist.
            //'--lifetime=365d' // Certificate will be valid for 10 years (default).
            box.ipAddr,
          ],
        );

        // Generate a client certificate "<certs-dir>/client.crt" and key "<certs-dir>/node.key".
        Process.runSync(
          cockroachBin,
          [
            'cert',
            'create-client',
            '--certs-dir=${certsDir.path}',
            '--ca-key=$tmpCVDir${pathSep}ca.key',
            '--key-size=4096',
            '--overwrite', // Certificate and key files are overwritten if they exist.
            //'--lifetime=365d' // Certificate will be valid for 10 years (default).
            box.name,
          ],
        );

        // Store setup data to ballotbox specific config directory
        await saveSetupSettingsModelToFile(
          setupData,
          '${boxDir.path}settings.json',
        );
      });

      futureList.add(bbIsolate);
    }

    // await all ballot box threads
    await Future.wait(futureList);

    // Generate a new key if nessarry
    await crypto.getExportEncKey(overwriteKey: true);

    // Encrypt ballotbox data and export
    //? Running this function inside an Isolate leads to a crash of the whole app. (╯`Д´)╯︵ ┻━┻
    await crypto.zipAndEncryptDirectories(tmpCVDir, appCVDir);

    // Committe Node & Client
    final ecCertsDir = await getCockroachCertsDir();
    final cvDataDir = await getCVDataDir();

    await Isolate.run(() async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

      // Generate a node certificate "<certs-dir>/node.crt" and key "<certs-dir>/node.key".
      await Process.run(
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

      await Process.run(
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

      // Rename Node key and cert to commiittee specific name
      await File('$tmpCVDir${pathSep}node.key').copy('$ecCertsDir${pathSep}node.key');
      await File('$tmpCVDir${pathSep}node.crt').copy('$ecCertsDir${pathSep}node.crt');
      await File('$tmpCVDir${pathSep}client.root.key').copy('$ecCertsDir${pathSep}client.root.key');
      await File('$tmpCVDir${pathSep}client.root.crt').copy('$ecCertsDir${pathSep}client.root.crt');

      await File('$tmpCVDir${pathSep}ca.crt').copy('$ecCertsDir${pathSep}ca.crt');

      await saveSetupSettingsModelToFile(setupData, '$cvDataDir${pathSep}settings.json');
    });

    // Encrypt ballotbox data and export
    await crypto.zipAndEncryptDirectories(
      await getAppDirPath(),
      await getAppDirPath(),
    );

    File('$cvDataDir.zip.enc').renameSync(await getCommitteeDataFilePath());

    // Delete temporary directory
    await Isolate.run(() {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      Directory(tmpCVDir).deleteSync(recursive: true);
    });
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

    if (!Directory(bbDir).existsSync()) {
      // Store decryption password
      await crypto.storeExportEncKey(boxDataPassword);

      // Copy encrypted file to application dir
      if (filePath != ballotboxFile) {
        await File(ballotboxFile).writeAsBytes(
          await File(filePath).readAsBytes(),
        );
      }

      // decrypt and unpack ballotbox data
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
    }

    final setupData = await loadSetupSettingsModelFromFile('$bbDir${pathSep}settings.json');

    return setupData;
  }

  /// Return [SetupSettingsModel] from encrypted storage.
  Future<SetupSettingsModel> loadCommittee() async {
    final appCVDir = await getAppDirPath();
    final ecDir = await getCVDataDir();
    final ecFile = await getCommitteeDataFilePath();

    if (!Directory(ecDir).existsSync() && File(ecFile).existsSync()) {
      // Decrypt ballotbox data
      await crypto.decryptAndUnzipFile(ecFile, appCVDir);

      // Set file permissions for keys correctly
      await changeAllFilePermissions(await getAppDirPath(), '600');
    }

    final setupData = await loadSetupSettingsModelFromFile('$ecDir${pathSep}settings.json');

    return setupData;
  }
}
