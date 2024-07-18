import 'package:campus_vote/core/crypto/crypto.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/core/state/state_utils.dart';
import 'package:campus_vote/setup/setup_utils.dart';
import 'package:campus_vote/setup/widgets/alert_dialog.dart';
import 'package:campus_vote/setup/widgets/ballotbox_form.dart';
import 'package:campus_vote/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SetupForm extends StatefulWidget {
  final crypto = serviceLocator<Crypto>();
  final campusVoteState = serviceLocator<CampusVoteState>();
  final setupForm = GlobalKey<FormBuilderState>();

  SetupForm({super.key});

  @override
  State<StatefulWidget> createState() => SetupFormState();
}

class SetupFormState extends State<SetupForm> {
  String encKeyToShow = '';

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.setupForm,
      clearValueOnUnregister: true,
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderDateRangePicker(
                        name: FORMKEY_ELECTION_PERIOD,
                        locale:
                            Locale(AppLocalizations.of(context)!.localeName),
                        decoration: InputDecoration(
                          label: Text(
                            AppLocalizations.of(context)!.setupFormPeriod,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontWeight: FontWeight.w100),
                          ),
                        ),
                        validator: FormBuilderValidators.required(),
                        firstDate: DateTime.now().add(
                          const Duration(days: 1),
                        ), // tomorrow
                        lastDate: DateTime.now().add(
                          const Duration(days: 730),
                        ), // in 2 years
                      ),
                    ),
                    // just a placeholder that has the exact same size
                    IconButton(icon: Container(), onPressed: () {})
                  ],
                ),
                BallotBoxForm(setupForm: widget.setupForm),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                child: CVButton(
                  onPressed: () async {
                    if (widget.setupForm.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Success')),
                      );
                      widget.setupForm.currentState!.save();
                      final setupModel = setupFormDataToModel(
                        widget.setupForm.currentState!.value,
                      );
                      if (widget.campusVoteState.state ==
                          CVStates.AWAITING_SETUP) {
                        await widget.campusVoteState.changeState(
                          CVStates.INITIALIZING_ELECTION,
                          setupData: setupModel,
                        );
                      }

                      if (context.mounted) {
                        final encKey = await widget.crypto.getExportEncKey();
                        setState(() => encKeyToShow = encKey.base64);

                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => ShowPasswordDialog(
                            password: encKey.base64,
                          ),
                        );
                      }
                    }
                  },
                  labelText: 'Validate',
                  icon: const Icon(Icons.check_outlined),
                ),
              ),
              Expanded(flex: 2, child: Container()),
            ],
          ),
        ],
      ),
    );
  }
}
