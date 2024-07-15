import 'package:campus_vote/core/crypto/crypto.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/core/state/state_utils.dart';
import 'package:campus_vote/setup/widgets/popup_dialog.dart';
import 'package:campus_vote/setup/widgets/setup_form.dart';
import 'package:campus_vote/setup/widgets/setup_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class SetupView extends StatelessWidget {
  final campusVoteState = serviceLocator<CampusVoteState>();
  final crypto = serviceLocator<Crypto>();

  SetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setupTitle),
        actions: [
          if (campusVoteState.state == CVStates.AWAITING_SETUP)
            IconButton(
              onPressed: () async {
                final FilePickerResult? boxDataFile =
                    await FilePicker.platform.pickFiles();
                if (boxDataFile != null) {
                  final boxDataPassword = await showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const PasswordDialog(),
                  );
                  if (campusVoteState.state == CVStates.AWAITING_SETUP) {
                    try {
                      await campusVoteState.changeState(
                        CVStates.INITIALIZING_ELECTION,
                        boxDataFile: boxDataFile,
                        boxDataPassword: boxDataPassword,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.warning_outlined,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 20),
                              Text(e.toString()),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                }
              },
              icon: Icon(
                Icons.add_card_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              tooltip: AppLocalizations.of(context)!.tooltipLoadSetup,
            ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: getStateWidget(),
      ),
    );
  }

  Widget getStateWidget() {
    switch (campusVoteState.state) {
      case CVStates.AWAITING_SETUP:
        return SetupForm();
      default:
        return SetupInfo();
    }
  }
}
