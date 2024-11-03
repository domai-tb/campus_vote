import 'package:campus_vote/core/api/generated/vote.pbgrpc.dart';
import 'package:flutter/material.dart';

class VoteCount extends StatelessWidget {
  final VotingDayStats day;

  const VoteCount({required this.day, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            '${day.totalVotes}',
            style: const TextStyle(fontWeight: FontWeight.bold),
            textScaler: const TextScaler.linear(2),
          ),
        ),
        Text('  ${day.morningVotes} | ${day.afternoonVotes}'),
      ],
    );
  }
}
