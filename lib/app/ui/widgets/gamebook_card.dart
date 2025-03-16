import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/routes/app_routes.dart';

class GamebookCard extends StatelessWidget {
  final Scenario gamebook;
  final AuthController authController;
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;

  const GamebookCard({
    Key? key,
    required this.gamebook,
    required this.authController,
    required this.onGameSelected,
    required this.onScenarioSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.toNamed(
            '${AppRoutes.scenario}/${gamebook.id}',
            arguments: gamebook,
          );
          onScenarioSelected();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gamebook Cover/Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.colorScheme.secondaryContainer
                          : theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.secondary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.auto_stories,
                      size: 32,
                      color: isDark
                          ? theme.colorScheme.onSecondaryContainer
                          : theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Gamebook Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gamebook.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(
                              context,
                              icon: Icons.person_outline,
                              label: 'ID: ${gamebook.author.id}',
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              context,
                              icon: Icons.calendar_today_outlined,
                              label: gamebook.creationDate
                                  .toString()
                                  .split(' ')[0],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (gamebook.description != null &&
                  gamebook.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  gamebook.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withOpacity(isDark ? 0.7 : 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Info Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Get.toNamed(
                        '${AppRoutes.scenario}/${gamebook.id}',
                        arguments: gamebook,
                      );
                      onScenarioSelected();
                    },
                    icon: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: isDark
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.primary,
                    ),
                    label: Text(
                      'details'.tr,
                      style: TextStyle(
                        color: isDark
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color: (isDark
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.primary)
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Play Button
                  ElevatedButton.icon(
                    onPressed: authController.isAuthenticated
                        ? () async {
                            // TODO: this is the same as in game selection screen / scenario screen
                            final gameController =
                                Get.find<GamePlayController>();
                            await gameController
                                .createGameFromScenario(gamebook.id);
                            Get.toNamed(AppRoutes.gameDetail.replaceFirst(
                                ':id',
                                gameController.currentGame.value!.idGame
                                    .toString()));
                            onGameSelected();
                          }
                        : () => _showLoginDialog(context),
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 20,
                    ),
                    label: Text('play'.tr),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer
            .withOpacity(isDark ? 0.3 : 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'login_required'.tr,
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            'login_to_play_message'.tr,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
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
                Get.back();
                Get.toNamed(AppRoutes.profile);
              },
              child: Text('login'.tr),
            ),
          ],
        );
      },
    );
  }
}
