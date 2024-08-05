import 'dart:io';

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

class SetupForm extends StatelessWidget {
  final crypto = serviceLocator<Crypto>();
  final campusVoteState = serviceLocator<CampusVoteState>();
  final setupForm = GlobalKey<FormBuilderState>();

  final BuildContext setupPageContext;

  SetupForm({super.key, required this.setupPageContext});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NetworkInterface.list(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return FormBuilder(
          key: setupForm,
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
                            locale: Locale(AppLocalizations.of(context)!.localeName),
                            decoration: InputDecoration(
                              label: Text(
                                AppLocalizations.of(context)!.setupFormPeriod,
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
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
                        const SizedBox(width: 20),
                        // TODO: DropDownMenu from Network Interfaces
                        // Expanded(
                        //   child: FormBuilderDropdown(
                        //     name: FORMKEY_COMMITTEE_IP,
                        //     items: buildDropdownList(snapshot.data!),
                        //   ),
                        // ),
                        // just a placeholder that has the exact same size
                        Expanded(
                          child: FormBuilderTextField(
                            name: FORMKEY_COMMITTEE_IP,
                            validator: ballotBoxIPValidator,
                            decoration: InputDecoration(
                              label: Text(
                                AppLocalizations.of(context)!.setupFormCommitteeIP,
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
                              ),
                            ),
                          ),
                        ),
                        IconButton(icon: Container(), onPressed: () {}),
                      ],
                    ),
                    BallotBoxForm(setupForm: setupForm),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(flex: 2, child: Container()),
                  Expanded(
                    child: CVButton(
                      onPressed: () async {
                        if (setupForm.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Success')),
                          );
                          setupForm.currentState!.save();
                          final setupModel = setupFormDataToModel(
                            setupForm.currentState!.value,
                          );
                          if (campusVoteState.state == CVStates.AWAITING_SETUP) {
                            await campusVoteState
                                .changeState(
                              CVStates.INITIALIZING_ELECTION,
                              setupData: setupModel,
                            )
                                .then((_) async {
                              await crypto.getExportEncKey().then((encKey) async {
                                await showDialog(
                                  context: setupPageContext,
                                  builder: (BuildContext context) => ShowPasswordDialog(password: encKey.base64),
                                );
                              });
                            });
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
      },
    );
  }

  List<DropdownMenuItem> buildDropdownList(
    List<NetworkInterface> netInterfaces,
  ) {
    final List<DropdownMenuItem> retVal = [];

    for (final interface in netInterfaces) {
      for (final addr in interface.addresses) {
        retVal.add(DropdownMenuItem(child: Text(addr.address)));
      }
    }

    return retVal;
  }
}
