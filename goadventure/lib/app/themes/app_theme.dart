import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: ColorScheme.light().copyWith(
    secondary: Colors.blueAccent, // Use secondary color for accent
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.blue,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Replaces bodyText1
    bodyMedium: TextStyle(color: Colors.black87), // Replaces bodyText2
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  colorScheme: ColorScheme.dark().copyWith(
    secondary: Colors.blueAccent, // Use secondary color for accent
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    color: Colors.blueGrey,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Replaces bodyText1
    bodyMedium: TextStyle(color: Colors.white70), // Replaces bodyText2
  ),
);
