import 'package:campus_vote/settings/settings_model.dart';
import 'package:campus_vote/settings/settings_utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {
  /// Holds the currently used settings.
  late Settings _currentSettings = loadSettings();

  /// Holds static package info, e.g. platform or version
  late PackageInfo packageInfo;

  /// Storage for preferences
  late SharedPreferences prefs;

  SettingsController({required this.packageInfo, required this.prefs});

  /// Settings getter
  Settings get currentSettings => _currentSettings;

  /// Get current version
  String get currentVersion => packageInfo.version;

  /// Get current language.
  Locale get language => _currentSettings.language;

  /// Get current theme mode .
  ThemeMode get themeMode => _currentSettings.themeMode;

  void updateLanguage(Locale? newLanguage) {
    if (newLanguage == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newLanguage == _currentSettings.language) return;

    _updateSettings(_currentSettings.copyWith(language: newLanguage));
  }

  /// Load the saved settings or initialize new settings
  Settings loadSettings() {
    return Settings(
      themeMode: strToTm(prefs.getString(PREFS_THEMEMODE) ?? 'system'),
      useSystemTextScaling: prefs.getBool(PREFS_TEXTSCALING) ?? false,
      latestVersion:
          prefs.getString(PREFS_LATESTVERSION) ?? packageInfo.version,
      language: Locale(prefs.getString(PREFS_LANGUAGE) ?? 'en'),
    );
  }

  /// Update and persist the ThemeMode based on the user's selection.
  void updateThemeMode(ThemeMode? newThemeMode) {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _currentSettings.themeMode) return;

    _updateSettings(_currentSettings.copyWith(themeMode: newThemeMode));
  }

  /// Notifies the listeners whenever the settings are changed and saves
  /// the new settings.
  void _updateSettings(Settings newSettings) {
    _currentSettings = newSettings;
    notifyListeners();

    prefs.setString(PREFS_THEMEMODE, tMtoStr(newSettings.themeMode));
    prefs.setBool(PREFS_TEXTSCALING, newSettings.useSystemTextScaling);
    prefs.setString(PREFS_LATESTVERSION, newSettings.latestVersion);
    prefs.setString(PREFS_LANGUAGE, newSettings.language.languageCode);
  }
}
