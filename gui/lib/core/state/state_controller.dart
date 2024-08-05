import 'dart:async';

import 'package:campus_vote/core/state/state_service.dart';
import 'package:campus_vote/core/state/state_utils.dart';
import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/header/header_service.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CampusVoteState extends ChangeNotifier {
  final FlutterSecureStorage storage;
  final SetupServices setupServices;
  final HeaderServices headerServices;
  final CampusVoteStateServices stateServices;

  CVStates state;
  SetupSettingsModel? setupData;
  FilePickerResult? boxDataFile;
  String? boxDataPassword;

  CampusVoteState({
    required this.storage,
    required this.setupServices,
    required this.headerServices,
    required this.stateServices,
    this.state = CVStates.AWAITING_SETUP,
    this.setupData,
    this.boxDataFile,
    this.boxDataPassword,
  }) {
    _handleState().then((_) => notifyListeners());
  }

  bool apiIsBussy() {
    return state != CVStates.ELECTION_STARTED;
  }

  bool apiIsStarted() {
    return state == CVStates.ELECTION_STARTED;
  }

  Future<void> changeState(
    CVStates newState, {
    SetupSettingsModel? setupData,
    FilePickerResult? boxDataFile,
    String? boxDataPassword,
  }) async {
    this.setupData = setupData ?? this.setupData;
    this.boxDataFile = boxDataFile ?? this.boxDataFile;
    this.boxDataPassword = boxDataPassword ?? this.boxDataPassword;

    state = newState;
    notifyListeners();

    await _handleState();
    notifyListeners();
  }

  Future<void> _handleState() async {
    switch (state) {
      case CVStates.AWAITING_SETUP:
        // Fresh started GUI application
        final storedStateName = await storage.read(key: STORAGEKEY_STATE);
        if (storedStateName != null) {
          if (stateFromStr(storedStateName) != CVStates.AWAITING_SETUP) {
            boxDataPassword = await storage.read(key: STORAGEKEY_BALLOTBOX_ENC_KEY);
            if (!await setupServices.isElectionCommittee()) {
              setupData = await setupServices.loadBallotBox(
                await getBallotBoxDataFilePath(),
                boxDataPassword!,
              );
            } else {
              setupData = await setupServices.loadCommittee();
            }

            state = stateFromStr(storedStateName);
            await changeState(state);
          }
        }
        break;
      case CVStates.INITIALIZING_ELECTION:
        try {
          // Election is newly setup
          if (setupData != null) {
            await setupServices.createElection(setupData!);
          }
          // Campus Vote is loading ballot box data
          else if (boxDataFile != null && boxDataPassword != null) {
            setupData = await setupServices.loadBallotBox(
              boxDataFile!.files.single.path!,
              boxDataPassword!,
            );
            await storage.write(
              key: STORAGEKEY_BALLOTBOX_ENC_KEY,
              value: boxDataPassword,
            );
          }
        } catch (e) {
          await changeState(CVStates.AWAITING_SETUP);
          rethrow;
        }

        await changeState(CVStates.READY_TO_START_ELECTION);
        break;
      case CVStates.READY_TO_START_ELECTION:
        // TODO: Handle state
        break;
      case CVStates.STARTING_ELECTION:
        if (setupData != null) {
          try {
            await stateServices.startingElection(setupData!);
            await changeState(CVStates.ELECTION_STARTED);
          } catch (e) {
            print(e);
            await changeState(CVStates.READY_TO_START_ELECTION);
          }
          await changeState(CVStates.ELECTION_STARTED);
        } else {
          await changeState(CVStates.AWAITING_SETUP);
        }
        break;
      case CVStates.ELECTION_STARTED:
        try {
          await stateServices.startingElection(setupData!);
        } catch (e) {
          // should return an error when services already started
          // => currently after re-start
          print(e);
        }
        break;
      case CVStates.ELECTION_PAUSED:
        // TODO: Handle state
        break;
      case CVStates.ELECTION_OFFLINE:
        // TODO: Handle state
        break;
    }

    // Store current state within keyring
    await storage.write(key: STORAGEKEY_STATE, value: state.toString());
  }
}
