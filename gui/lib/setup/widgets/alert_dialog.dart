import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowPasswordDialog extends StatelessWidget {
  final String password;

  const ShowPasswordDialog({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Your Password'),
      content: TextField(
        controller: TextEditingController(text: password),
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: password));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
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
          child: Text('Close'),
        ),
      ],
    );
  }
}
