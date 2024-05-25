import 'package:campus_vote/models/db_conf.dart';
import 'package:campus_vote/settings/settings_controller.dart';
import 'package:flutter/material.dart';

class CampusVoteDBConfForm extends StatefulWidget {
  final SettingsController controller;

  const CampusVoteDBConfForm({super.key, required this.controller});

  @override
  CampusVoteDBConfFormState createState() {
    return CampusVoteDBConfFormState();
  }
}

class CampusVoteDBConfFormState extends State<CampusVoteDBConfForm> {
  final _campusVoteDBConfFormState = GlobalKey<FormState>();

  // TextFormField controllers
  final _formFieldUsername = TextEditingController();
  final _formFieldHost = TextEditingController();
  final _formFieldPort = TextEditingController();
  final _formFieldDatabase = TextEditingController();
  final _formFieldRootCert = TextEditingController();
  final _formFieldClientCert = TextEditingController();
  final _formFieldClientKey = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _campusVoteDBConfFormState,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: _formFieldUsername,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                labelText: 'Username',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                hintText: 'Hint Text',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                filled: true,
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: _formFieldHost,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                labelText: 'Host Adress',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                hintText: 'Hint Text',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                filled: true,
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: _formFieldPort,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                labelText: 'Port',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                hintText: 'Hint Text',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                filled: true,
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: _formFieldDatabase,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                labelText: 'Database Name',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                hintText: 'Hint Text',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                filled: true,
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: _formFieldRootCert,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                labelText: 'Root Certificate',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                hintText: 'Hint Text',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                filled: true,
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: _formFieldClientCert,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                labelText: 'Client Certificate',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                hintText: 'Hint Text',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                filled: true,
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: _formFieldClientKey,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                labelText: 'Client Key',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                hintText: 'Hint Text',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                ),
                filled: true,
                isDense: false,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_campusVoteDBConfFormState.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                widget.controller.setDBConf(
                  CampusVoteDBConf(
                    username: _formFieldUsername.text,
                    host: _formFieldHost.text,
                    port: int.parse(_formFieldPort.text),
                    database: _formFieldDatabase.text,
                    rootCert: _formFieldRootCert.text,
                    clientCert: _formFieldClientCert.text,
                    clientKey: _formFieldClientKey.text,
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
