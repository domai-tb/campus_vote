import 'package:flutter/material.dart';

class Settings {
  final ThemeMode themeMode;
  final bool useSystemTextScaling;
  final String latestVersion;
  final Locale language;

  Settings({
    this.themeMode = ThemeMode.system,
    this.useSystemTextScaling = false,
    this.latestVersion = '',
    this.language = const Locale('en'),
  });

  Settings copyWith({
    ThemeMode? themeMode,
    bool? useSystemTextScaling,
    String? latestVersion,
    Locale? language,
  }) =>
      Settings(
        themeMode: themeMode ?? this.themeMode,
        useSystemTextScaling: useSystemTextScaling ?? this.useSystemTextScaling,
        latestVersion: latestVersion ?? this.latestVersion,
        language: language ?? this.language,
      );
}
