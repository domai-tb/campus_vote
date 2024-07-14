import 'package:flutter/material.dart';

/// Returns true if screen is in mobile mode
bool isMobil(BuildContext context) {
  return MediaQuery.of(context).size.width < 850;
}

/// Returns true if screen is in tablet mode
bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;
}

/// Returns true if screen is in desktop mode
bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width >= 1100;
}
