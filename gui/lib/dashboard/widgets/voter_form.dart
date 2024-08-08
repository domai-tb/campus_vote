import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/dashboard/dashboard_utils.dart';
import 'package:campus_vote/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class VoterForm extends StatelessWidget {
  final voterForm = GlobalKey<FormBuilderState>();

  VoterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: voterForm,
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
                      child: FormBuilderTextField(
                        name: FORMKEY_STUDENTID,
                        validator: studentIdValidator,
                        decoration: InputDecoration(
                          label: Text(
                            AppLocalizations.of(context)!.setupFormCommitteeIP,
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    CVButton(
                      onPressed: () async {
                        if (voterForm.currentState!.validate()) {
                          voterForm.currentState!.save();

                          // TODO: Call register vote
                          final client = serviceLocator<CampusVoteAPIClient>();
                          await client.countVote(voterForm.currentState!.value[FORMKEY_STUDENTID]).then((msg) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          });
                        }
                      },
                      labelText: 'Submit',
                      icon: const Icon(Icons.wysiwyg_outlined),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
