import 'dart:async';

import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/api/generated/vote.pbgrpc.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/responsiv.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/dashboard/widgets/turnout_circle.dart';
import 'package:campus_vote/dashboard/widgets/vote_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';
import 'package:intl/intl.dart';

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
          if (snapshot.hasError) {
            return Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ],
            );
          } else {
            if (stats == null) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TurnoutCircle(totalVoters: stats!.totalVoters.toInt(), totalVotes: stats!.totalVotes.toInt()),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: buildTable(),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(locals!.dashboardTableInfoTxt),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text('${locals.voterInfoVotesTitle}: ${stats!.totalVotes}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text('${locals.voterInfoVotersTitle}: ${stats!.totalVoters}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  '${locals.dashboardAvrgOtherVotesTxt}: ${getAveragePercentageOfVotesFromOtherBoxes(stats!)}%',
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      );
    } else if (campusVoteState.electionIsReadyToStart()) {
      return Center(
        child: Text(
          locals!.infTxtPleaseStartElec,
          style: theme.textTheme.headlineMedium,
        ),
      );
    } else if (campusVoteState.apiIsStarting()) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: Text(
          locals!.infTxtPleaseSetupAElec,
          style: theme.textTheme.headlineMedium!.copyWith(color: Theme.of(context).primaryColor),
        ),
      );
    }
  }

  String getAveragePercentageOfVotesFromOtherBoxes(ElectionStats stats) {
    double retVal = 0;

    for (final box in stats.ballotBoxes) {
      if (box.totalVotes.toInt() != 0) {
        retVal += box.votesFromOtherBoxes.toInt() * (100 / box.totalVotes.toInt());
      }
    }

    return NumberFormat('0.##').format(retVal / stats.ballotBoxes.length);
  }

  List<TableRow> buildTable() {
    final locals = AppLocalizations.of(context)!;

    final retVal = <TableRow>[
      TableRow(
        children: [
          TableCell(
            child: Text(
              locals.ballotBoxTxt,
              style: const TextStyle(fontWeight: FontWeight.w800),
              textScaler: TextScaler.linear(isDesktop(context) ? 1.5 : 1.2),
            ),
          ),
          TableCell(
            child: Text(
              locals.mondayTxt,
              style: const TextStyle(fontWeight: FontWeight.w800),
              textScaler: TextScaler.linear(isDesktop(context) ? 1.5 : 1.2),
            ),
          ),
          TableCell(
            child: Text(
              locals.tuesdayTxt,
              style: const TextStyle(fontWeight: FontWeight.w800),
              textScaler: TextScaler.linear(isDesktop(context) ? 1.5 : 1.2),
            ),
          ),
          TableCell(
            child: Text(
              locals.wendsdayTxt,
              style: const TextStyle(fontWeight: FontWeight.w800),
              textScaler: TextScaler.linear(isDesktop(context) ? 1.5 : 1.2),
            ),
          ),
          TableCell(
            child: Text(
              locals.thursdayTxt,
              style: const TextStyle(fontWeight: FontWeight.w800),
              textScaler: TextScaler.linear(isDesktop(context) ? 1.5 : 1.2),
            ),
          ),
          TableCell(
            child: Text(
              locals.fridayTxt,
              style: const TextStyle(fontWeight: FontWeight.w800),
              textScaler: TextScaler.linear(isDesktop(context) ? 1.5 : 1.2),
            ),
          ),
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
        rowCells.add(TableCell(child: VoteCount(day: day)));
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
