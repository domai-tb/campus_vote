import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class TurnoutCircle extends StatelessWidget {
  final int totalVotes;
  final int totalVoters;

  const TurnoutCircle({required this.totalVoters, required this.totalVotes, super.key});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 100,
      lineWidth: 13,
      animation: true,
      percent: totalVotes * (100 / totalVoters),
      center: Center(
        child: Text(
          '${totalVotes * (100 / totalVoters)}%\n${AppLocalizations.of(context)!.turnoutTxt}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.green,
    );
  }
}
