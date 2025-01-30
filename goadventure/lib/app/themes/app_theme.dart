import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF322505), // Foreground color
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF322505), // Foreground
    secondary: const Color(0xFFFA802F), // Accent
    surface: const Color(0xFFF3E8CA), // Background
    background: const Color(0xFFF3E8CA), // Background
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: const Color(0xFF322505), // Foreground
  ),
  scaffoldBackgroundColor: const Color(0xFFF3E8CA), // Background
  appBarTheme: AppBarTheme(
    color: const Color(0xFF322505), // Foreground
    elevation: 2,
    iconTheme: const IconThemeData(color: Color(0xFFFA802F)), // Accent
    titleTextStyle: TextStyle(
      color: const Color(0xFFFA802F), // Accent
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      // Replaces headline6
      color: const Color(0xFF322505), // Foreground
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    titleMedium: TextStyle(
      // Replaces subtitle1
      color: const Color(0xFF322505), // Foreground
      fontSize: 18,
    ),
    bodyLarge: TextStyle(
      color: const Color(0xFF322505), // Foreground
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: const Color(0xFF9C8B73), // Secondary
      fontSize: 14,
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFA802F), // Accent
      foregroundColor: const Color(0xFFF3E8CA), // Background
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF9C8B73), // Secondary
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF9C8B73), // Secondary
    secondary: const Color(0xFFFA802F), // Accent
    surface: const Color(0xFF322505), // Foreground
    background: const Color(0xFF322505), // Foreground
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onBackground: const Color(0xFF9C8B73), // Secondary
  ),
  scaffoldBackgroundColor: const Color(0xFF322505), // Foreground
  appBarTheme: AppBarTheme(
    color: const Color(0xFF9C8B73), // Secondary
    elevation: 2,
    iconTheme: const IconThemeData(color: Color(0xFFFA802F)), // Accent
    titleTextStyle: TextStyle(
      color: const Color(0xFFFA802F), // Accent
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: const Color(0xFFFA802F), // Accent
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: const Color(0xFF9C8B73), // Secondary
      fontSize: 14,
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF9C8B73).withOpacity(0.3), // Secondary
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFA802F), // Accent
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
);
