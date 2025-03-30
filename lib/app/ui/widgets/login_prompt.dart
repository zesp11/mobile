import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/routes/app_routes.dart';

class LoginPromptWidget extends StatelessWidget {
  const LoginPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.person_outlined,
                  size: 40,
                  color: colorScheme.secondary, // Use accent color
                ),
                title: Text(
                  'Get the full experience!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark ? Colors.white : colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in to access your game history, achievements, '
                'and personalized recommendations.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? colorScheme.tertiary
                          : colorScheme.onBackground.withOpacity(0.8),
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.login, color: colorScheme.secondary),
                      label: Text(
                        'Sign In',
                        style: TextStyle(color: colorScheme.secondary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.secondary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        // The profile shows Login if it's not logged in
                        // It allows then to keep the bottom bar
                        Get.rootDelegate.toNamed(AppRoutes.profile);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Get.toNamed(AppRoutes.register),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
