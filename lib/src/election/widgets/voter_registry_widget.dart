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
          onPressed: () {},
          child: const Text('View Voters'),
        ),
      ),
    );
  }
}
