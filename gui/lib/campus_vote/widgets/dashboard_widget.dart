import 'package:campus_vote/campus_vote/api/grpc_client.dart';
import 'package:campus_vote/generated/api.pbgrpc.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CampusVoteAPIClient client = CampusVoteAPIClient();

  late ElectionStats stats;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateStats(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return const Placeholder();
      },
    );
  }

  Future<void> updateStats() async {
    setState(() async {
      stats = await client.getElectionStats();
      print(stats);
    });
  }
}
