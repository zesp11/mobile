import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gotale/app/services/settings_service.dart';
import 'package:logger/logger.dart';

class SettingsController extends GetxController {
  final SettingsService settingService;
  final logger = Get.find<Logger>();

  SettingsController({required this.settingService});

  // Reactive values for theme, layout style, language, and notifications
  var themeMode = ThemeMode.system.obs;
  var layoutStyle = 'vertical'.obs;
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
    Get.updateLocale(Locale(newLanguage));
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
    // TODO: dry
    // TODO: change those hardcoded values
    updateTheme(ThemeMode.dark);
    updateLayoutStyle('vertical');
    updateLanguage('pl');
    toggleNotifications(false);

    logger.d("Settings reset to defaults");
  }
}
