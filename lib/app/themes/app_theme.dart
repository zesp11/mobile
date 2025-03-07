import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF2C3E50), // Modern slate blue
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF2C3E50), // Modern slate blue
    secondary: const Color(0xFFFA802F), // Keeping orange accent
    surface: const Color(0xFFF8F9FA), // Light gray surface
    background: const Color(0xFFFFFFFF), // Pure white background
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: const Color(0xFF2C3E50), // Slate blue
    tertiary: const Color(0xFF95A5A6), // Subtle gray
  ),
  scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Light gray
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: const Color(0xFFFA802F).withOpacity(0.1),
    height: 65,
    labelTextStyle: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return TextStyle(
          color: const Color(0xFFFA802F),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );
      }
      return TextStyle(
        color: const Color(0xFF95A5A6),
        fontSize: 13,
      );
    }),
    iconTheme: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const IconThemeData(
          color: Color(0xFFFA802F),
          size: 24,
        );
      }
      return IconThemeData(
        color: const Color(0xFF95A5A6),
        size: 24,
      );
    }),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black12,
    elevation: 3,
  ),
  appBarTheme: AppBarTheme(
    color: const Color(0xFF2C3E50), // Slate blue
    elevation: 0, // Modern flat design
    iconTheme: const IconThemeData(color: Color(0xFFFA802F)), // Orange accent
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600, // Slightly less bold for modern look
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: const Color(0xFF2C3E50),
      fontWeight: FontWeight.w600,
      fontSize: 24,
      letterSpacing: -0.5, // Modern typography
    ),
    titleMedium: TextStyle(
      color: const Color(0xFF2C3E50),
      fontSize: 18,
      letterSpacing: -0.3,
    ),
    bodyLarge: TextStyle(
      color: const Color(0xFF2C3E50),
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: const Color(0xFF95A5A6), // Subtle gray
      fontSize: 14,
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 1, // Subtle elevation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // Slightly more rounded
    ),
    shadowColor: Colors.black.withOpacity(0.1), // Subtle shadow
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFA802F), // Orange accent
      foregroundColor: Colors.white,
      elevation: 0, // Flat design
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF1A1F25), // Dark mode background
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF1A1F25),
    secondary: const Color(0xFFFA802F), // Keeping orange accent
    surface: const Color(0xFF22272E), // Slightly lighter than background
    background: const Color(0xFF1A1F25),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    tertiary: const Color(0xFF8B97A5), // Muted blue-gray
  ),
  scaffoldBackgroundColor: const Color(0xFF1A1F25),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: const Color(0xFF22272E),
    indicatorColor: const Color(0xFFFA802F).withOpacity(0.15),
    height: 65,
    labelTextStyle: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return TextStyle(
          color: const Color(0xFFFA802F),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );
      }
      return TextStyle(
        color: const Color(0xFF8B97A5),
        fontSize: 13,
      );
    }),
    iconTheme: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const IconThemeData(
          color: Color(0xFFFA802F),
          size: 24,
        );
      }
      return IconThemeData(
        color: const Color(0xFF8B97A5),
        size: 24,
      );
    }),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black26,
    elevation: 3,
  ),
  appBarTheme: AppBarTheme(
    color: const Color(0xFF22272E),
    elevation: 0,
    iconTheme: const IconThemeData(color: Color(0xFFFA802F)),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 24,
      letterSpacing: -0.5,
    ),
    titleMedium: TextStyle(
      color: Colors.white.withOpacity(0.95),
      fontSize: 18,
      letterSpacing: -0.3,
    ),
    bodyLarge: TextStyle(
      color: Colors.white.withOpacity(0.95),
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: const Color(0xFFB4BDC7), // Lighter gray for better readability
      fontSize: 14,
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF22272E),
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    shadowColor: Colors.black.withOpacity(0.3),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFA802F),
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
);
