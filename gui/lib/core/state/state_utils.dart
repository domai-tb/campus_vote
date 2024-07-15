const STORAGEKEY_STATE = 'campus_vote_state';
const STORAGEKEY_BALLOTBOX_ENC_KEY = 'ballotbox_enc_key';

enum CVStates {
  AWAITING_SETUP,
  INITIALIZING_ELECTION,
  READY_TO_START_ELECTION,
  ELECTION_STARTED,
  ELECTION_PAUSED,
  ELECTION_OFFLINE,
}

CVStates stateFromStr(String stateName) {
  if (stateName == CVStates.AWAITING_SETUP.toString()) {
    return CVStates.AWAITING_SETUP;
  } else if (stateName == CVStates.INITIALIZING_ELECTION.toString()) {
    return CVStates.INITIALIZING_ELECTION;
  } else if (stateName == CVStates.READY_TO_START_ELECTION.toString()) {
    return CVStates.READY_TO_START_ELECTION;
  } else if (stateName == CVStates.ELECTION_STARTED.toString()) {
    return CVStates.ELECTION_STARTED;
  } else if (stateName == CVStates.ELECTION_PAUSED.toString()) {
    return CVStates.ELECTION_PAUSED;
  } else if (stateName == CVStates.ELECTION_OFFLINE.toString()) {
    return CVStates.ELECTION_OFFLINE;
  } else {
    throw Exception('unexpected state "$stateName"');
  }
}
