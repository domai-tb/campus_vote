import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Colors.black,
  canvasColor: Color.fromARGB(255, 174, 174, 211),
  cardColor: Colors.white,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.black,
    secondary: Color.fromRGBO(21, 0, 62, 1),
    tertiary: Color.fromRGBO(15, 155, 15, 1),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  fontFamily: 'SF-Pro',
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: TextStyle(
      color: Colors.black,
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
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 129, 129, 129),
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
);
