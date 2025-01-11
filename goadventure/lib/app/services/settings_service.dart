import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class SettingsService extends GetxService {
  final _storage = GetStorage();

  // Keys for storing preferences
  static const String _themeKey = 'theme';
  static const String _layoutKey = 'layoutStyle';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications';

  // Default values
  final ThemeMode defaultTheme = ThemeMode.system;
  final String defaultLayoutStyle = 'buttons';
  final String defaultLanguage = 'en';
  final bool defaultNotifications = true;

  // Save theme
  Future<void> saveTheme(ThemeMode theme) async {
    await _storage.write(_themeKey, theme.toString());
  }

  // Get theme
  ThemeMode getTheme() {
    final themeString = _storage.read(_themeKey) ?? defaultTheme.toString();
    switch (themeString) {
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  // Save layout style
  Future<void> saveLayoutStyle(String style) async {
    await _storage.write(_layoutKey, style);
  }

  // Get layout style
  String getLayoutStyle() {
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

  // Reset all settings to default
  void resetSettings() {
    saveTheme(ThemeMode.system);
    saveLayoutStyle('buttons');
    saveLanguage('en');
    saveNotifications(true);
  }
}
