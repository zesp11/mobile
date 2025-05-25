import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { error, success, warning, info }

void showAppSnackbar({
  required String title,
  required String message,
  required SnackbarType type,
}) {
  final theme = Get.theme;
  late final Color accentColor;
  late final Color backgroundColor;
  late final IconData icon;

  switch (type) {
    case SnackbarType.error:
      accentColor = const Color(0xFFF44336); // Brighter error red
      backgroundColor = const Color(0x33F44336); // 20% opacity red
      icon = Icons.error_outline_rounded;
      break;
    case SnackbarType.success:
      accentColor = const Color(0xFF4CAF50); // Material success green
      backgroundColor = const Color(0x334CAF50); // 20% opacity green
      icon = Icons.check_circle_rounded;
      break;
    case SnackbarType.warning:
      accentColor = theme.colorScheme.secondary; // Your orange accent
      backgroundColor = const Color(0x33FA802F); // 20% opacity orange
      icon = Icons.warning_rounded;
      break;
    case SnackbarType.info:
      accentColor = theme.colorScheme.tertiary; // Muted blue-gray
      backgroundColor = const Color(0x338B97A5); // 20% opacity tertiary
      icon = Icons.info_outline_rounded;
      break;
  }

  Get.snackbar(
    '',
    '',
    titleText: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: accentColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
      ],
    ),
    messageText: Text(
      message,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: accentColor.withOpacity(0.9),
        height: 1.3,
      ),
    ),
    snackPosition: SnackPosition.TOP,
    backgroundColor: backgroundColor,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    borderRadius: 12,
    colorText: accentColor,
    borderWidth: 1.0,
    borderColor: theme.colorScheme.surface.withOpacity(0.15),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
    animationDuration: const Duration(milliseconds: 200),
    duration: const Duration(seconds: 3),
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
    dismissDirection: DismissDirection.horizontal,
    isDismissible: true,
    icon: const SizedBox.shrink(),
    shouldIconPulse: false,
    overlayBlur: 0.5,
    leftBarIndicatorColor: accentColor.withOpacity(0.8),
  );
}
