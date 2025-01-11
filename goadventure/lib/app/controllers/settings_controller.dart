import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:goadventure/app/services/settings_service.dart';
import 'package:logger/logger.dart';

class SettingsController extends GetxController {
  final SettingsService settingService;
  final logger = Get.find<Logger>();

  SettingsController({required this.settingService});

  // Reactive values for theme, layout style, language, and notifications
  var themeMode = ThemeMode.system.obs;
  var layoutStyle = 'stacked'.obs;
  var language = 'en'.obs;
  var notifications = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize settings from storage
    themeMode.value = settingService.getTheme();
    layoutStyle.value = settingService.getLayoutStyle();
    language.value = settingService.getLanguage();
    notifications.value = settingService.getNotifications();
    logger.i(
        "Settings loaded: theme=$themeMode, layout=$layoutStyle, language=$language, notifications=$notifications");
  }

  // Update theme
  void updateTheme(ThemeMode newTheme) {
    themeMode.value = newTheme;
    logger.i("Theme updated to: $newTheme");
    settingService.saveTheme(newTheme);
  }

  // Update layout style
  void updateLayoutStyle(String newStyle) {
    layoutStyle.value = newStyle;
    logger.i("Layout style updated to: $newStyle");
    settingService.saveLayoutStyle(newStyle);
  }

  // Update language
  void updateLanguage(String newLanguage) {
    language.value = newLanguage;
    settingService.saveLanguage(newLanguage);
    logger.i("Language updated to: $newLanguage");
  }

  // Toggle notifications
  void toggleNotifications(bool isEnabled) {
    notifications.value = isEnabled;
    logger.i("Notifications enabled: $isEnabled");
    settingService.saveNotifications(isEnabled);
  }

  // Reset all settings to default
  void resetSettings() {
    themeMode.value = ThemeMode.system;
    layoutStyle.value = 'buttons';
    language.value = 'en';
    notifications.value = true;

    settingService.resetSettings();
    logger.d("Settings reset to defaults");
  }
}
