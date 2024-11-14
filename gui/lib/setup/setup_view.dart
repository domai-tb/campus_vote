import 'dart:io';

import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/crypto/crypto.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/core/state/state_service.dart';
import 'package:campus_vote/core/state/state_utils.dart';
import 'package:campus_vote/core/utils/path_utils.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:campus_vote/setup/widgets/popup_dialog.dart';
import 'package:campus_vote/setup/widgets/setup_form.dart';
import 'package:campus_vote/setup/widgets/setup_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class SetupView extends StatelessWidget {
  final campusVoteState = serviceLocator<CampusVoteState>();
  final stateServices = serviceLocator<CampusVoteStateServices>();
  final crypto = serviceLocator<Crypto>();
  final setupServices = serviceLocator<SetupServices>();

  SetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;

    return FutureBuilder(
      initialData: false,
      future: setupServices.isElectionCommittee(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(locals.setupTitle),
            actions: [
              if (campusVoteState.state == CVStates.ELECTION_STARTED)
                if (snapshot.data!)
                  IconButton(
                    onPressed: () async {
                      final FilePickerResult? voterFile = await FilePicker.platform.pickFiles();

                      if (voterFile != null) {
                        try {
                          // Add voter data to current database
                          await stateServices.createVoterDatabase(voterFile);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(locals.createVotersTxt)),
                          );
                        } catch (e) {
                          // ignore: use_build_context_synchronously
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
                    },
                    icon: Icon(
                      Icons.add_reaction_outlined,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
                    ),
                    tooltip: locals.tooltipLoadSetup,
                  ),
              if (campusVoteState.state == CVStates.AWAITING_SETUP)
                IconButton(
                  onPressed: () async {
                    final FilePickerResult? boxDataFile = await FilePicker.platform.pickFiles();
                    if (boxDataFile != null) {
                      final boxDataPassword = await showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const PasswordDialog(),
                      );

                      try {
                        await campusVoteState.changeState(
                          CVStates.INITIALIZING_ELECTION,
                          boxDataFile: boxDataFile,
                          boxDataPassword: boxDataPassword,
                        );
                      } catch (e) {
                        if (context.mounted) {
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
                  tooltip: locals.tooltipLoadSetup,
                ),
              if (campusVoteState.state != CVStates.AWAITING_SETUP)
                IconButton(
                  onPressed: () async {
                    serviceLocator.unregister<CampusVoteAPIClient>();
                    await Future.wait([
                      Directory(await getAppDirPath()).delete(recursive: true),
                      crypto.storage.deleteAll(),
                      campusVoteState.changeState(CVStates.AWAITING_SETUP),
                    ]);
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  tooltip: locals.tooltipDeleteSetup,
                ),
              const SizedBox(width: 20),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: getStateWidget(context),
          ),
        );
      },
    );
  }

  Widget getStateWidget(BuildContext context) {
    switch (campusVoteState.state) {
      case CVStates.AWAITING_SETUP:
        return SetupForm(setupPageContext: context);
      case CVStates.INITIALIZING_ELECTION:
        return const Center(child: CircularProgressIndicator());
      default:
        return SetupInfo();
    }
  }
}
