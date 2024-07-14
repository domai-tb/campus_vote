import 'package:campus_vote/setup/setup_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class NewBallotBoxField extends StatelessWidget {
  final String name;
  final VoidCallback? onDelete;
  const NewBallotBoxField({
    super.key,
    required this.name,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: FormBuilderTextField(
              name: '$name$FORMKEY_ADD_NAME',
              validator: ballotBoxNameValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                label: Text(
                  AppLocalizations.of(context)!.setupFormBoxName,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontWeight: FontWeight.w100),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: FormBuilderTextField(
              name: '$name$FORMKEY_ADD_IP',
              validator: ballotBoxIPValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                label: Text(
                  AppLocalizations.of(context)!.setupFormBoxIP,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontWeight: FontWeight.w100),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
