import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:flutter/material.dart';

class SetupInfo extends StatelessWidget {
  final campusVoteState = serviceLocator<CampusVoteState>();

  SetupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    if (campusVoteState.setupData == null) {
      print(campusVoteState.setupData);
      return const Center(child: CircularProgressIndicator());
    }

    final data = campusVoteState.setupData!;
    final electionStart = data.electionPeriod.start;
    final electionEnd = data.electionPeriod.end;
    final electionPeriod =
        '${electionStart.day}.${electionStart.month}. - ${electionEnd.day}.${electionEnd.month}.${electionEnd.year}';

    final column = <Widget>[
      Row(
        children: [
          const Expanded(child: Text('Election Period')),
          const SizedBox(width: 20),
          Expanded(child: Text(electionPeriod)),
        ],
      ),
    ];

    for (final box in data.ballotBoxes) {
      column.add(
        Row(
          children: [
            Expanded(child: Text(box.name)),
            const SizedBox(width: 20),
            Expanded(child: Text(box.ipAddr)),
          ],
        ),
      );
    }

    return Column(children: column);
  }
}
