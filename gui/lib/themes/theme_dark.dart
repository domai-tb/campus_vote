import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  canvasColor: const Color(0xFF2E2E48),
  cardColor: const Color.fromRGBO(17, 25, 38, 1),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    secondary: Color.fromRGBO(49, 113, 236, 1),
    tertiary: Color.fromRGBO(15, 155, 15, 1),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.black,
    surface: Color.fromRGBO(14, 20, 32, 1),
    onSurface: Colors.white,
  ),
  fontFamily: 'SF-Pro',
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 26,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 1,
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(
      color: Color.fromRGBO(184, 186, 191, 1),
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    labelSmall: TextStyle(
      //color: Color.fromRGBO(184, 186, 191, 1),
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: Color.fromRGBO(184, 186, 191, 1),
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
);
