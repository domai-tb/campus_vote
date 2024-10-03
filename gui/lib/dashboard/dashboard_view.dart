import 'dart:async';

import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/api/generated/vote.pbgrpc.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final campusVoteState = serviceLocator<CampusVoteState>();

  late CampusVoteAPIClient client;

  Timer? updateTimer;
  ElectionStats? stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locals = AppLocalizations.of(context);

    if (campusVoteState.apiHasStarted() && serviceLocator.isRegistered<CampusVoteAPIClient>()) {
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
    } else if (campusVoteState.electionIsReadyToStart()) {
      return Center(
        child: Text(
          locals!.infTxtPleaseStartElec,
          style: theme.textTheme.headlineMedium,
        ),
      );
    } else {
      return Center(
        child: Text(
          locals!.infTxtPleaseSetupAElec,
          style: theme.textTheme.headlineMedium,
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
      ),
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

      if (newStats != stats) {
        setState(() => stats = newStats);
      }
    }
  }
}
