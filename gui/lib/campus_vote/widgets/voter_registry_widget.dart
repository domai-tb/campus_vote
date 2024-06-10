import 'package:campus_vote/campus_vote/api/grpc_client.dart';
import 'package:flutter/material.dart';

class VoterRegistry extends StatefulWidget {
  const VoterRegistry({super.key});

  @override
  State<VoterRegistry> createState() => _VoterRegistryState();
}

class _VoterRegistryState extends State<VoterRegistry> {
  final CampusVoteAPIClient client = CampusVoteAPIClient();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('sdfsdf')),
              Text('sdfsdf'),
            ],
          ),
          Text('sdfsdf'),
          Text('sdfsdf'),
          Text('sdfsdf'),
          Text('sdfsdf'),
          Text('sdfsdf'),
          Text('sdfsdf'),
          Text('sdfsdf'),
          Text('sdfsdf'),
        ],
      ),
    );
  }
}
