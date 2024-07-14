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
            flex: 2,
            child: Text('Current State is ${campusVoteState.state}'),
          ),
          Expanded(
            child: CVButton(
              icon: campusVoteState.apiIsStarted()
                  ? const Icon(Icons.pause_outlined)
                  : const Icon(Icons.play_arrow_outlined),
              labelText: campusVoteState.apiIsStarted()
                  ? 'Shutdown Campus Vote'
                  : 'Start API',
              onPressed: () {
                campusVoteState.changeState(CVStates.ELECTION_STARTED);
              },
            ),
          ),
        ],
      ),
    );
  }
}
