import 'package:flutter/material.dart';

class ElectionSetup extends StatelessWidget {
  const ElectionSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Generate Stuff'),
        ),
      ),
    );
  }
}