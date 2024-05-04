import 'package:flutter/material.dart';

class VoterRegistry extends StatefulWidget {
  VoterRegistry({Key? key}) : super(key: key);

  @override
  _VoterRegistryState createState() => _VoterRegistryState();
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
