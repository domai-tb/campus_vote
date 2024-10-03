import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/core/state/state_utils.dart';
import 'package:campus_vote/widgets/button.dart';
import 'package:flutter/material.dart';

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
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: CVButton(
                  icon: const Icon(Icons.play_arrow_outlined),
                  labelText: 'Start API',
                  onPressed: () => campusVoteState.changeState(CVStates.STARTING_ELECTION),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
