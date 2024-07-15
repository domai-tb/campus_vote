import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

const FORMKEY_ADD_BALLOTBOX = '_setupBallotBox';
const FORMKEY_ADD_IP = '_ipAddr';
const FORMKEY_ADD_NAME = '_name';
const FORMKEY_BALLOTBOX_IP = 'setupBallotBox_ipAddr';
const FORMKEY_BALLOTBOX_NAME = 'setupBallotBox_name';
const FORMKEY_ELECTION_PERIOD = 'setupFormPeriod';

const MODEL_BOX_NAME_KEY = 'name';
const MODEL_BOX_IPADDR_KEY = 'ipAddr';

const MODEL_SET_PERIOD_KEY = 'electionPeriod';
const MODEL_SET_PERIOD_START_KEY = 'start';
const MODEL_SET_PERIOD_END_KEY = 'end';
const MODEL_SET_BOXES_KEY = 'ballotBoxes';

const STORAGEKEY_COMMITTEE = 'isElectionCommittee';

/// Validators for setup form that validates an IP.
final ballotBoxIPValidator = FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  FormBuilderValidators.ip(),
]);

/// Validators for setup form that validates an ballotbox name.
final ballotBoxNameValidator = FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  FormBuilderValidators.maxLength(63),
  FormBuilderValidators.maxWordsCount(1)
]);

/// Creates a [SetupSettingsModel] based on validated form data by the
/// [SetupView] form widget.
SetupSettingsModel setupFormDataToModel(Map<String, dynamic> formData) {
  final List<BallotBoxSetupModel> boxes = [];

  formData.forEach((formKey, formValue) {
    final formKeyParts = formKey.split('_');
    // ballotbox fields only
    if (formKeyParts.contains(FORMKEY_ADD_NAME.substring(1))) {
      boxes.add(
        BallotBoxSetupModel(
          name: formValue,
          ipAddr:
              formData['${formKeyParts[0]}_${formKeyParts[1]}$FORMKEY_ADD_IP'],
        ),
      );
    }
  });

  return SetupSettingsModel(
    ballotBoxes: boxes,
    electionPeriod: formData[FORMKEY_ELECTION_PERIOD],
  );
}
