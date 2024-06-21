import 'package:campus_vote/generated/api.pbgrpc.dart';
import 'package:flutter/material.dart';

class BallotboxStatsWidget extends StatelessWidget {
  /// The name of the Ballotbox
  final BallotBoxStats stats;

  const BallotboxStatsWidget({
    required this.stats,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 25),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  stats.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 50),
            Row(children: buildTable()),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${stats.totalVotes}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildTable() {
    final List<Widget> retWidgets = [];

    for (final day in stats.votesPerDay) {
      retWidgets.addAll([
        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text('${day.totalVotes}'),
                Text('${day.morningVotes} / ${day.afternoonVotes}'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 50),
      ]);
    }

    return retWidgets;
  }
}
