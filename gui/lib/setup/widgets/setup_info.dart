import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/core/state/state_utils.dart';
import 'package:campus_vote/setup/setup_models.dart';
import 'package:campus_vote/setup/setup_services.dart';
import 'package:flutter/material.dart';

class SetupInfo extends StatefulWidget {
  final campusVoteState = serviceLocator<CampusVoteState>();
  final setupService = serviceLocator<SetupServices>();

  SetupInfo({super.key});

  @override
  State<StatefulWidget> createState() => SetupInfoState();
}

class SetupInfoState extends State<SetupInfo> {
  BallotBoxSetupModel boxSelf = const BallotBoxSetupModel();

  @override
  Widget build(BuildContext context) {
    if (widget.campusVoteState.setupData == null || widget.campusVoteState.state == CVStates.INITIALIZING_ELECTION) {
      return const Center(child: CircularProgressIndicator());
    }
    loadBallotBoxData();

    final data = widget.campusVoteState.setupData!;
    final electionStart = data.electionPeriod.start;
    final electionEnd = data.electionPeriod.end;
    final electionPeriod = '${electionStart.day}.${electionStart.month}. - ${electionEnd.day}.${electionEnd.month}.${electionEnd.year}';

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
            Expanded(
              child: Text(
                box.name,
                style: TextStyle(
                  color: box.name == boxSelf.name ? Theme.of(context).colorScheme.tertiary : null,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                box.ipAddr,
                style: TextStyle(
                  color: box.name == boxSelf.name ? Theme.of(context).colorScheme.tertiary : null,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(children: column);
  }

  Future<void> loadBallotBoxData() async {
    try {
      final boxData = await widget.setupService.getBallotBoxSelf(
        widget.campusVoteState.setupData!,
      );
      setState(() {
        boxSelf = boxData;
      });
    } catch (e) {
      // ignore because this indicates that this instance ist the election committee
    }
  }
}
