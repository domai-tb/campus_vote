import 'dart:async';

import 'package:campus_vote/campus_vote/api/grpc_client.dart';
import 'package:campus_vote/campus_vote/widgets/ballotbox_stats.dart';
import 'package:campus_vote/generated/api.pbgrpc.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CampusVoteAPIClient client = CampusVoteAPIClient();

  ElectionStats stats = ElectionStats();

  Timer? updateTimer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      updateStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateStats(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: buildStats(),
          ),
        );
      },
    );
  }

  Future<void> updateStats() async {
    final apiStats = await client.getElectionStats();
    if (mounted) setState(() => stats = apiStats);
  }

  List<Widget> buildStats() {
    List<Widget> retWidgets = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Election Year: ${stats.electionYear}'),
            ),
          ),
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Total Votes: ${stats.totalVotes}'),
            ),
          ),
        ],
      ),
      // Header widget
      Row(
        children: [
          Expanded(
            child: Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Text('BallotBox'),
                    const SizedBox(width: 50),
                    Text(getDayName(0)),
                    const SizedBox(width: 50),
                    Text(getDayName(1)),
                    const SizedBox(width: 50),
                    Text(getDayName(2)),
                    const SizedBox(width: 50),
                    Text(getDayName(3)),
                    const SizedBox(width: 50),
                    Text(getDayName(4)),
                    const SizedBox(width: 50),
                    const Text('Total Votes'),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    ];

    for (final bbStat in stats.ballotBoxes) {
      retWidgets.add(
        BallotboxStatsWidget(stats: bbStat),
      );
    }

    return retWidgets;
  }

  String getDayName(int day) {
    switch (day) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wendsday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      default:
        return 'ERROR';
    }
  }
}
