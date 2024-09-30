import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/failures.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/header/header_service.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_services.dart';

class CampusVoteStateServices {
  final SetupServices setupServices;
  final HeaderServices headerServices;

  CampusVoteStateServices({
    required this.headerServices,
    required this.setupServices,
  });

  Future<void> startingElection(SetupSettingsModel setupData) async {
    final BallotBoxSetupModel? boxSelf;
    if (!await setupServices.isElectionCommittee()) {
      boxSelf = await setupServices.getBallotBoxSelf(setupData);
    } else {
      boxSelf = null; // there no box data if node is election committee
    }

    await headerServices.startCockroachNode(setupData, boxSelf);
    await headerServices.startCampusVoteAPI(setupData, boxSelf);

    try {
      // This client will be accessable by all classes and is a singleton.
      serviceLocator.registerSingleton(
        CampusVoteAPIClient(
          rootCert: '/home/domai/Coding/campus_vote/certs/api-ca.crt',
          clientCert: '/home/domai/Coding/campus_vote/certs/api-client.crt',
          clientKey: '/home/domai/Coding/campus_vote/certs/api-client.key',
        ),
      );
    } catch (_) {
      throw APIClientAlreadyRegistered();
    }
  }
}
