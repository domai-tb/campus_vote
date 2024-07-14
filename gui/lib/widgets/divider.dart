import 'package:flutter/material.dart';

class CVDivider extends StatelessWidget {
  const CVDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      height: 1,
    );
  }
}
