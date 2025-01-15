import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: Column(
        children: [
          // Language Selection
          ListTile(
            title: Text('language'.tr),
            trailing: Obx(
              () => DropdownButton<String>(
                value: settingsController.language.value,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'pl',
                    child: Text('Polski'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settingsController.updateLanguage(value);
                  }
                },
              ),
            ),
          ),

          // Notifications Toggle
          ListTile(
            title: Text('notifications'.tr),
            trailing: Obx(
              () => Switch(
                value: settingsController.notifications.value,
                onChanged: (value) {
                  settingsController.toggleNotifications(value);
                },
              ),
            ),
          ),

          // Theme Toggle
          ListTile(
            title: Text('theme'),
            trailing: Obx(
              () => DropdownButton<ThemeMode>(
                value: settingsController.themeMode.value,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('light'.tr),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('dark'.tr),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('system'.tr),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settingsController.updateTheme(value);
                  }
                },
              ),
            ),
          ),

          // Layout Style Selection
          ListTile(
            title: Text('decision_layout_style'.tr),
            trailing: Obx(() {
              return DropdownButton<String>(
                value: settingsController.layoutStyle.value,
                items: [
                  DropdownMenuItem(
                    value: 'stacked',
                    child: Text('vertical'),
                  ),
                  DropdownMenuItem(
                    value: 'horizontal',
                    child: Text('horizontal'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settingsController.updateLayoutStyle(value);
                  }
                },
              );
            }),
          ),

          // Reset Settings Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                settingsController.resetSettings();
              },
              child: Text('reset_settings'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
