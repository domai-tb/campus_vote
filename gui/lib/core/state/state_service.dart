import 'dart:convert';
import 'dart:io';

import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/api/generated/vote.pb.dart';
import 'package:campus_vote/core/failures.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/header/header_service.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:protobuf/protobuf.dart';

class CampusVoteStateServices {
  final SetupServices setupServices;
  final HeaderServices headerServices;

  CampusVoteStateServices({
    required this.headerServices,
    required this.setupServices,
  });

  /// Initialize the database with given list of students / voter.
  /// Expect CSV data with the following header:
  ///   Martrikelnummer, Vorname, Nachname, Urne, Fakultät, Senatswahlkreis
  Future<void> createVoterDatabase(FilePickerResult voterFile) async {
    final List<List<dynamic>> voterData = [];

    final client = serviceLocator<CampusVoteAPIClient>();
    final Stream<List> inputStream = File(voterFile.files.first.path!).openRead();

    inputStream.transform(utf8.decoder).transform(const LineSplitter()).listen(
      (String line) {
        final List<dynamic> voter = line.split(','); // split by comma
        voterData.add(voter);
      },
      onDone: () async {
        // skip CSV header
        for (final voter in voterData.sublist(1)) {
          final statusMsg = await client.createVoter(
            Voter(
              studentId: StudentId(num: parseLongInt(voter[0])), // Martrikelnummer
              firstname: voter[1], // Vorname
              lastname: voter[2], // Nachname
              ballotBox: voter[3], // Urne
              faculity: voter[4], // Fakultät
              shk: voter[5], // SHK Wahlkreis
              status: 0, // can be ignored / just for convenience
            ),
          );

          if (statusMsg.status != 0) {
            //! Print voter to stdout if it could not be created.
            //! This error should be handled manually.

            // ignore: avoid_print
            print('[ERROR] ${statusMsg.msg}: $voter');
          }
        }
      },
      onError: (_) {
        throw Exception('failed to read voter database');
      },
    );
  }

  Future<void> startingElection(SetupSettingsModel setupData) async {
    final BallotBoxSetupModel? boxSelf;
    if (!await setupServices.isElectionCommittee()) {
      boxSelf = await setupServices.getBallotBoxSelf(setupData);
    } else {
      boxSelf = null; // there no box data if node is election committee
    }

    await headerServices.startCockroachNode(setupData, boxSelf);
    await headerServices.startCampusVoteAPI(setupData, boxSelf);

    final apiCertPath = await getAPICertsDir();

    try {
      // This client will be accessable by all classes and is a singleton.
      serviceLocator.registerSingleton(
        CampusVoteAPIClient(
          rootCert: '$apiCertPath${pathSep}api-ca.crt',
          clientCert: '$apiCertPath${pathSep}api-client.crt',
          clientKey: '$apiCertPath${pathSep}api-client.key',
        ),
      );
    } catch (_) {
      throw APIClientAlreadyRegistered();
    }
  }
}
