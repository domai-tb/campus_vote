import 'dart:async';

import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/api/generated/api.pb.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  final campusVoteState = serviceLocator<CampusVoteState>();

  DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late CampusVoteAPIClient client;

  Timer? updateTimer;
  ElectionStats? stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.campusVoteState.apiIsStarted() &&
        serviceLocator.isRegistered<CampusVoteAPIClient>()) {
      client = serviceLocator<CampusVoteAPIClient>();
      return FutureBuilder(
        future: updateStats(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: buildTable(),
          );
        },
      );
    } else {
      return Container(
        color: Colors.accents.first,
        child: Center(
          child: Text(
            'Dashboard',
            style: theme.textTheme.headlineSmall,
          ),
        ),
      );
    }
  }

  List<TableRow> buildTable() {
    final retVal = <TableRow>[
      const TableRow(
        children: [
          TableCell(child: Text('Ballot Box')),
          TableCell(child: Text('Monday')),
          TableCell(child: Text('Tuesday')),
          TableCell(child: Text('Wendsday')),
          TableCell(child: Text('Thursday')),
          TableCell(child: Text('Friday')),
        ],
      )
    ];

    if (stats == null) {
      return retVal;
    }

    for (final box in stats!.ballotBoxes) {
      final rowCells = <TableCell>[
        TableCell(child: Text(box.name)),
      ];
      for (final day in box.votesPerDay) {
        rowCells.add(TableCell(child: Text('${day.totalVotes} Votes')));
      }
      retVal.add(TableRow(children: rowCells));
    }

    return retVal;
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      updateStats();
    });
  }

  Future<void> updateStats() async {
    if (serviceLocator.isRegistered<CampusVoteAPIClient>()) {
      client = serviceLocator<CampusVoteAPIClient>();
      final newStats = await client.getElectionStats();
      setState(() => stats = newStats);
    }
  }
}
