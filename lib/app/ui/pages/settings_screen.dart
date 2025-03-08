import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16.0 : size.width * 0.1,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'settings_title'.tr,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'settings_subtitle'.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onBackground
                        .withOpacity(isDark ? 0.7 : 0.8),
                  ),
                ),
                const SizedBox(height: 32),

                // Appearance Section
                _buildSectionHeader(
                    context, 'appearance'.tr, Icons.palette_outlined),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  children: [
                    _buildSettingItem(
                      context,
                      title: 'theme'.tr,
                      icon: Icons.dark_mode_outlined,
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
                          underline: SizedBox(),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    _buildDivider(context),
                    _buildSettingItem(
                      context,
                      title: 'decision_layout_style'.tr,
                      icon: Icons.view_agenda_outlined,
                      trailing: Obx(
                        () => DropdownButton<String>(
                          value: settingsController.layoutStyle.value,
                          items: [
                            DropdownMenuItem(
                              value: 'vertical',
                              child: Text('vertical'.tr),
                            ),
                            DropdownMenuItem(
                              value: 'matrix',
                              child: Text('matrix'.tr),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              settingsController.updateLayoutStyle(value);
                            }
                          },
                          underline: SizedBox(),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Preferences Section
                _buildSectionHeader(
                    context, 'preferences'.tr, Icons.settings_outlined),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  context,
                  children: [
                    _buildSettingItem(
                      context,
                      title: 'language'.tr,
                      icon: Icons.language_outlined,
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
                          underline: SizedBox(),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    _buildDivider(context),
                    _buildSettingItem(
                      context,
                      title: 'notifications'.tr,
                      subtitle: 'notifications_description'.tr,
                      icon: Icons.notifications_outlined,
                      trailing: Obx(
                        () => Switch(
                          value: settingsController.notifications.value,
                          onChanged: (value) {
                            settingsController.toggleNotifications(value);
                          },
                          activeColor: theme.colorScheme.primary,
                          activeTrackColor: isDark
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.primary.withOpacity(0.3),
                          inactiveThumbColor: theme.colorScheme.surface,
                          inactiveTrackColor:
                              theme.colorScheme.onSurface.withOpacity(0.3),
                          thumbColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return isDark
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.primary;
                            }
                            return theme.colorScheme.surface;
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Reset Settings Button
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: Text('reset_settings_confirmation'.tr),
                          content: Text('reset_settings_message'.tr),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'cancel'.tr,
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                settingsController.resetSettings();
                                Get.back();
                                Get.snackbar(
                                  'success'.tr,
                                  'settings_reset_success'.tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      Colors.green.withOpacity(0.1),
                                  colorText: Colors.green,
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: 12,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                foregroundColor: theme.colorScheme.onError,
                              ),
                              child: Text('reset'.tr),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.restore_outlined,
                      color: theme.colorScheme.error,
                    ),
                    label: Text(
                      'reset_settings'.tr,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'settings_fab',
        onPressed: () => Get.back(),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: Icon(Icons.arrow_back),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Icon(
          icon,
          color:
              isDark ? theme.colorScheme.secondary : theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark
                ? theme.colorScheme.secondary
                : theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context,
      {required List<Widget> children}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.onSurface.withOpacity(isDark ? 0.7 : 0.8),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withOpacity(isDark ? 0.6 : 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      thickness: 1,
      color: theme.colorScheme.outline.withOpacity(0.1),
    );
  }
}
