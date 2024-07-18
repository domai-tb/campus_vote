import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowPasswordDialog extends StatelessWidget {
  final String password;

  const ShowPasswordDialog({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your Password'),
      content: TextField(
        controller: TextEditingController(text: password),
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: password));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password copied to clipboard!'),
                ),
              );
            },
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
