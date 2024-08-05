import 'package:campus_vote/setup/setup_utils.dart';
import 'package:campus_vote/setup/widgets/ballotbox_field.dart';
import 'package:campus_vote/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class BallotBoxForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> setupForm;

  const BallotBoxForm({super.key, required this.setupForm});

  @override
  State<BallotBoxForm> createState() => _BallotBoxFormState();
}

class _BallotBoxFormState extends State<BallotBoxForm> {
  final List<Widget> fields = [];
  var _newTextFieldId = 1;
  String savedValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: '0_$FORMKEY_BALLOTBOX_NAME',
                validator: ballotBoxNameValidator,
                decoration: InputDecoration(
                  label: Text(
                    AppLocalizations.of(context)!.setupFormBoxName,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: FormBuilderTextField(
                name: '0_$FORMKEY_BALLOTBOX_IP',
                validator: ballotBoxIPValidator,
                decoration: InputDecoration(
                  label: Text(
                    AppLocalizations.of(context)!.setupFormBoxIP,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
                  ),
                ),
              ),
            ),
            // just a placeholder that has the exact same size
            IconButton(icon: Container(), onPressed: () {}),
          ],
        ),
        ...fields,
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(flex: 3, child: Container()),
            const SizedBox(width: 20),
            Expanded(
              child: CVButton(
                icon: const Icon(Icons.add_box_outlined),
                labelText: AppLocalizations.of(context)!.setupFormAddBox,
                onPressed: () {
                  final newTextFieldName = '${_newTextFieldId++}$FORMKEY_ADD_BALLOTBOX';
                  final newTextFieldKey = ValueKey(_newTextFieldId);
                  setState(() {
                    fields.add(
                      NewBallotBoxField(
                        key: newTextFieldKey,
                        name: newTextFieldName,
                        onDelete: () {
                          setState(() {
                            fields.removeWhere((e) => e.key == newTextFieldKey);
                          });
                        },
                      ),
                    );
                  });
                },
              ),
            ),
            IconButton(icon: Container(), onPressed: () {}),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    savedValue = widget.setupForm.currentState?.value.toString() ?? '';
    super.initState();
  }
}
