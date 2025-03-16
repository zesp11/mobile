import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScenarioCard extends StatelessWidget {
  final Scenario gamebook;
  final AuthController authController;
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;

  const ScenarioCard({
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
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
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
                  // Improved Cover Image
                  _buildCoverImage(theme),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildInfoChip(
                              context,
                              icon: Icons.people_outline,
                              label: '${gamebook.limitPlayers} players',
                            ),
                            _buildInfoChip(
                              context,
                              icon: Icons.calendar_today_outlined,
                              label: dateFormat.format(gamebook.creationDate),
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
                ReadMoreText(
                  gamebook.description!,
                  trimLines: 2,
                  colorClickableText: theme.colorScheme.primary,
                  trimMode: TrimMode.Line,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withOpacity(isDark ? 0.7 : 0.8),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _buildActionButtons(context, theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: gamebook.idPhoto != 0
            ? Image.network(
                'https://picsum.photos/id/${gamebook.idPhoto}/200/200',
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.auto_stories,
                size: 32,
                color: theme.colorScheme.secondary,
              ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Author Info
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Text(
                gamebook.author.login[0].toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            title: Text(
              gamebook.author.login,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Action Buttons
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.info_outline,
                  color: theme.colorScheme.onSurface.withOpacity(0.7)),
              onPressed: () {
                Get.toNamed(
                  '${AppRoutes.scenario}/${gamebook.id}',
                  arguments: gamebook,
                );
                onScenarioSelected();
              },
            ),
            const SizedBox(width: 8),
            _buildPlayButton(context, theme, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context, ThemeData theme, bool isDark) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.play_arrow_rounded, size: 20),
      label: Text('play'.tr),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
      ),
      onPressed: authController.isAuthenticated
          ? () async {
              final gameController = Get.find<GamePlayController>();
              await gameController.createGameFromScenario(gamebook.id);
              Get.toNamed(AppRoutes.gameDetail.replaceFirst(
                  ':id', gameController.currentGame.value!.idGame.toString()));
              onGameSelected();
            }
          : () => _showLoginDialog(context),
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

// TODO: fix skeleton
class ScenarioCardSkeleton extends StatelessWidget {
  const ScenarioCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      effect: ShimmerEffect(
          // baseColor: theme.colorScheme.onPrimary,
          // highlightColor: theme.colorScheme.surface,
          ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Header Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Image Skeleton
                  Skeleton.replace(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: theme.colorScheme.secondaryContainer
                            .withOpacity(0.2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title and Chips
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Skeleton.replace(
                          child: Container(
                            width: double.infinity,
                            height: 24,
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Info Chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Skeleton.replace(
                              child: Container(
                                width: 100,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Skeleton.replace(
                              child: Container(
                                width: 120,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Description
              const SizedBox(height: 16),
              Column(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Skeleton.replace(
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Author and Action Buttons
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Author Info
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Skeleton.replace(
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              theme.colorScheme.onSurface.withOpacity(0.1),
                        ),
                      ),
                      title: Skeleton.replace(
                        child: Container(
                          width: 80,
                          height: 16,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Action Buttons
                  Row(
                    children: [
                      Skeleton.replace(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Skeleton.replace(
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
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
