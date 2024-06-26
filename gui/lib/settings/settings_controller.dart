import 'package:campus_vote/models/db_conf.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:campus_vote/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // PackageInfo: Version number etc.
  late PackageInfo _packageInfo;

  SettingsController(this._settingsService);

  // Allow Widgets to read package info
  PackageInfo get packageInfo => _packageInfo;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _packageInfo = await _settingsService.packageInfo();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> setDBConf(CampusVoteDBConf conf) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', conf.username);
    await prefs.setString('host', conf.host);
    await prefs.setInt('port', conf.port);
    await prefs.setString('database', conf.database);
    await prefs.setString('rootCert', conf.rootCert);
    await prefs.setString('clientCert', conf.clientCert);
    await prefs.setString('clientKey', conf.clientKey);
  }

  Future<CampusVoteDBConf> getDBConf() async {
    final prefs = await SharedPreferences.getInstance();
    return CampusVoteDBConf(
      username: prefs.getString('username') ?? '',
      host: prefs.getString('host') ?? '',
      port: prefs.getInt('port') ?? -1,
      database: prefs.getString('database') ?? '',
      rootCert: prefs.getString('rootCert') ?? '',
      clientCert: prefs.getString('clientCert') ?? '',
      clientKey: prefs.getString('clientKey') ?? '',
    );
  }
}
