import 'dart:ffi';

import 'package:campus_vote/ffi/db.g.dart';
import 'package:flutter/material.dart';

class VoterRegistry extends StatefulWidget {
  const VoterRegistry({super.key});

  @override
  State<VoterRegistry> createState() => _VoterRegistryState();
}

class _VoterRegistryState extends State<VoterRegistry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            final db = CampusVoteDB(
              DynamicLibrary.open('linux/campus_vote/db/db-linux-amd64.so'),
            );
            db.sum(1, 2);
          },
          child: const Text('View Voters'),
        ),
      ),
    );
  }
}
