import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/header/widgets/start_election_popup.dart';
import 'package:campus_vote/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class HeaderView extends StatelessWidget {
  final campusVoteState = serviceLocator<CampusVoteState>();

  HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Text('Current State is ${campusVoteState.state}'),
          ),
          if (campusVoteState.electionIsReadyToStart())
            Expanded(
              flex: 2,
              child: CVButton(
                icon: const Icon(Icons.play_arrow_outlined),
                labelText: AppLocalizations.of(context)!.btnStartElection,
                onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const StartElectionPopup(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
