// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:campus_vote/setup/setup_utils.dart';
import 'package:flutter/material.dart';

/// Ballot box setup configuration.
class BallotBoxSetupModel {
  final String name;
  final String ipAddr;

  const BallotBoxSetupModel({
    this.name = '',
    this.ipAddr = '',
  });

  Map<String, dynamic> toJson() => {
        MODEL_BOX_NAME_KEY: name,
        MODEL_BOX_IPADDR_KEY: ipAddr,
      };

  factory BallotBoxSetupModel.fromJson(Map<String, dynamic> json) {
    return BallotBoxSetupModel(
      name: json[MODEL_BOX_NAME_KEY],
      ipAddr: json[MODEL_BOX_IPADDR_KEY],
    );
  }

  @override
  String toString() {
    return '$name ($ipAddr)';
  }
}

/// Settings to setup a new election
class SetupSettingsModel {
  final DateTimeRange electionPeriod;
  final List<BallotBoxSetupModel> ballotBoxes;

  const SetupSettingsModel({
    required this.electionPeriod,
    required this.ballotBoxes,
  });

  Map<String, dynamic> toJson() => {
        MODEL_SET_PERIOD_KEY: {
          MODEL_SET_PERIOD_START_KEY: electionPeriod.start.toIso8601String(),
          MODEL_SET_PERIOD_END_KEY: electionPeriod.end.toIso8601String(),
        },
        MODEL_SET_BOXES_KEY: ballotBoxes.map((box) => box.toJson()).toList(),
      };

  factory SetupSettingsModel.fromJson(Map<String, dynamic> json) {
    return SetupSettingsModel(
      electionPeriod: DateTimeRange(
        start: DateTime.parse(
          json[MODEL_SET_PERIOD_KEY][MODEL_SET_PERIOD_START_KEY],
        ),
        end: DateTime.parse(
          json[MODEL_SET_PERIOD_KEY][MODEL_SET_PERIOD_END_KEY],
        ),
      ),
      ballotBoxes: (json[MODEL_SET_BOXES_KEY] as List)
          // ignore: unnecessary_lambdas
          .map((box) => BallotBoxSetupModel.fromJson(box))
          .toList(),
    );
  }
}

Future<SetupSettingsModel> loadSetupSettingsModelFromFile(
  String filePath,
) async {
  final file = File(filePath);
  final jsonString = await file.readAsString();
  final jsonData = jsonDecode(jsonString);
  return SetupSettingsModel.fromJson(jsonData);
}

Future<void> saveSetupSettingsModelToFile(
  SetupSettingsModel model,
  String filePath,
) async {
  final file = File(filePath);
  final jsonString = jsonEncode(model.toJson());
  await file.writeAsString(jsonString);
}
