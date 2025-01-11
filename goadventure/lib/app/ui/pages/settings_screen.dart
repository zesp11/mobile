import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          // Language Selection
          ListTile(
            title: Text('Language'),
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
                    child: Text('Polish'),
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
            title: Text('Notifications'),
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
            title: Text('Theme'),
            trailing: Obx(
              () => DropdownButton<ThemeMode>(
                value: settingsController.themeMode.value,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Default'),
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
            title: Text('Decision Layout Style'),
            trailing: Obx(
              () => DropdownButton<String>(
                value: settingsController.layoutStyle.value,
                items: [
                  DropdownMenuItem(
                    value: 'buttons',
                    child: Text('4 Buttons'),
                  ),
                  DropdownMenuItem(
                    value: 'circle',
                    child: Text('Circle with 4 Parts'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settingsController.updateLayoutStyle(value);
                  }
                },
              ),
            ),
          ),

          // Reset Settings Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                settingsController.resetSettings();
              },
              child: const Text('Reset Settings'),
            ),
          ),
        ],
      ),
    );
  }
}
