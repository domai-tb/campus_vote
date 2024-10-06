import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/core/state/state_utils.dart';
import 'package:campus_vote/header/header_service.dart';
import 'package:campus_vote/header/header_utils.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class StartElectionPopup extends StatefulWidget {
  const StartElectionPopup({super.key});

  @override
  State<StartElectionPopup> createState() => _StartElectionPopupState();
}

class _StartElectionPopupState extends State<StartElectionPopup> {
  bool isElectionCommittee = false;
  final startForm = GlobalKey<FormBuilderState>();
  final campusVoteState = serviceLocator<CampusVoteState>();
  final secureStorage = serviceLocator<FlutterSecureStorage>();
  final headerServices = serviceLocator<HeaderServices>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      contentTextStyle: Theme.of(context).textTheme.headlineSmall,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      buttonPadding: const EdgeInsets.only(left: 50, right: 50),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FormBuilder(
            key: startForm,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: FORMKEY_ENCRYPTION_PASSWORD,
                  validator: FormBuilderValidators.required(),
                  decoration: InputDecoration(
                    label: Text(
                      AppLocalizations.of(context)!.startFormPassword,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (startForm.currentState!.validate()) {
              startForm.currentState!.save();
              final formData = startForm.currentState!.value;

              await secureStorage.write(
                key: STORAGEKEY_DATABASE_ENCRYPTION_KEY,
                value: formData[FORMKEY_ENCRYPTION_PASSWORD],
              );

              final FilePickerResult? voterFile = await FilePicker.platform.pickFiles();

              if (voterFile != null) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();

                // Create voter directory as soon as API is ready
                headerServices.createVoterDatabase(voterFile.files.first.path!);

                // Start CockroachDB Node and API
                await campusVoteState.changeState(CVStates.STARTING_ELECTION);
              }
            }
          },
          child: Text(AppLocalizations.of(context)!.startFormVoterFile),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.btnTxtClose),
        ),
      ],
    );
  }

  @override
  void initState() {
    final setupServices = serviceLocator<SetupServices>();
    setupServices.isElectionCommittee().then(
          (isEc) => setState(() => isElectionCommittee = isEc),
        );
    super.initState();
  }
}
