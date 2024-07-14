import 'package:flutter/material.dart';

/// Constants

const PREFS_THEMEMODE = 'themeMode';
const PREFS_TEXTSCALING = 'useSystemTextScaling';
const PREFS_LATESTVERSION = 'latestVersion';
const PREFS_LANGUAGE = 'languageCode';

/// Functions

// converts theme mode to string
String tMtoStr(ThemeMode tM) {
  switch (tM) {
    case ThemeMode.system:
      return 'system';
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    default:
      return 'system';
  }
}

// converts string to theme mode
ThemeMode strToTm(String str) {
  switch (str) {
    case 'system':
      return ThemeMode.system;
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
