import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SettingsService extends GetxService {
  final _storage = GetStorage();
  final logger = Get.find<Logger>();

  // Keys for storing preferences
  static const String _themeKey = 'theme';
  static const String _layoutKey = 'layoutStyle';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications';
  static const String _firstLaunchKey = 'firstLaunch';

  // Default values
  final ThemeMode defaultTheme = ThemeMode.system;
  final String defaultLayoutStyle = 'stacked';
  final String defaultLanguage = 'en';
  final bool defaultNotifications = true;
  final bool defaultFirstLaunch = true;

  // Save theme
  Future<void> saveTheme(ThemeMode theme) async {
    await _storage.write(_themeKey, theme.toString());
  }

  // Get theme
  ThemeMode getTheme() {
    final themeString = _storage.read(_themeKey) ?? defaultTheme.toString();
    switch (themeString) {
      case 'ThemeMode.dark':
        logger.d("Return dark mode");
        return ThemeMode.dark;
      case 'ThemeMode.light':
        logger.d("Return light mode");
        return ThemeMode.light;
      default:
        logger.d("Return system mode ${ThemeMode.system.toString()}");
        return ThemeMode.system;
    }
  }

  // Save layout style
  Future<void> saveLayoutStyle(String style) async {
    await _storage.write(_layoutKey, style);
  }

  // Get layout style
  String getLayoutStyle() {
    // _storage.erase();
    return _storage.read(_layoutKey) ?? defaultLayoutStyle;
  }

  // Save language
  Future<void> saveLanguage(String language) async {
    await _storage.write(_languageKey, language);
  }

  // Get language
  String getLanguage() {
    return _storage.read(_languageKey) ?? defaultLanguage;
  }

  // Save notifications
  Future<void> saveNotifications(bool isEnabled) async {
    await _storage.write(_notificationsKey, isEnabled);
  }

  // Get notifications
  bool getNotifications() {
    return _storage.read(_notificationsKey) ?? defaultNotifications;
  }

  Future<void> setFirstLaunch(bool value) async {
    await _storage.write(_firstLaunchKey, value);
  }

  bool isFirstLaunch() {
    return _storage.read(_firstLaunchKey) ?? defaultFirstLaunch;
  }
}
