import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
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

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Always use column layout for actions and author info
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAuthorInfo(context, theme, gamebook.author),
            const SizedBox(height: 12),
            _buildButtonPair(context, theme, isDark),
          ],
        );
      },
    );
  }

  Widget _buildAuthorInfo(
      BuildContext context, ThemeData theme, Author author) {
    return Tooltip(
      message: author.bio ?? 'no_bio_available'.tr,
      child: GestureDetector(
        onTap: () => Get.toNamed('/profile/${author.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAuthorAvatar(theme, author),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author.login ?? 'Anonymous',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormat.yMMMd().format(author.creationDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonPair(BuildContext context, ThemeData theme, bool isDark) {
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildDetailsButton(context, theme),
          const SizedBox(width: 8),
          _buildPlayButton(context, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context, ThemeData theme) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.info_outline, size: 20),
        label: Text('details'.tr),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          backgroundColor: theme.colorScheme.surfaceVariant,
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          elevation: 1,
        ),
        onPressed: () {
          Get.toNamed('${AppRoutes.scenario}/${gamebook.id}',
              arguments: gamebook);
          onScenarioSelected();
        },
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, ThemeData theme, bool isDark) {
    final canPlay = true;
    final isReady = canPlay && authController.isAuthenticated;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120),
      child: ElevatedButton.icon(
        icon: Icon(
          canPlay ? Icons.play_arrow_rounded : Icons.error_outline,
          size: 20,
        ),
        label: Text(canPlay ? 'play'.tr : 'not_ready'.tr),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: isReady
                ? BorderSide.none
                : BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
          ),
          elevation: isReady ? 2 : 0,
          backgroundColor: isReady
              ? theme.colorScheme.secondary
              : theme.colorScheme.tertiary.withOpacity(0.1),
          foregroundColor: isReady
              ? theme.colorScheme.onSecondary
              : theme.colorScheme.tertiary,
        ),
        onPressed: isReady
            ? () async {/* ... */}
            : () => _handlePlayRestriction(context, canPlay),
      ),
    );
  }

  // Updated Card Styling
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(isDark ? 0.1 : 0.05),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {/* ... */},
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Improved responsive layout
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool useCompactLayout = constraints.maxWidth < 500;

                  return useCompactLayout
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCoverImage(theme),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gamebook.name!,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoChips(context),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCoverImage(theme),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    gamebook.name!,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.25,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoChips(context),
                                ],
                              ),
                            ),
                          ],
                        );
                },
              ),
              if (gamebook.description != null) ...[
                const SizedBox(height: 16),
                ReadMoreText(
                  gamebook.description!,
                  trimLines: 2,
                  colorClickableText: theme.colorScheme.secondary,
                  trimMode: TrimMode.Line,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withOpacity(isDark ? 0.85 : 0.75),
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              _buildActionButtons(context, theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChips(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildInfoChip(
          context,
          icon: Icons.people_outline,
          label: '${gamebook.limitPlayers} players',
        ),
        SizedBox(
          width: 8,
        ),
        _buildInfoChip(
          context,
          icon: Icons.calendar_today_outlined,
          label: DateFormat('MMM dd, yyyy').format(gamebook.creationDate),
        ),
      ],
    );
  }

  // Enhanced Info Chip Design
  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String label}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withOpacity(isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Improved Play Button with Status Awareness
  void _handlePlayRestriction(BuildContext context, bool canPlay) {
    if (!canPlay) {
      Get.snackbar(
        'unavailable'.tr,
        'no_first_step'.tr,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
      return;
    }
    _showLoginDialog(context);
  }

// Enhanced Info Button with Context Menu
  Widget _buildInfoButton(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      onSelected: (value) => _handleInfoMenuSelection(context, value),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'details',
          child: ListTile(
            leading: Icon(Icons.info, size: 20),
            title: Text('view_details'.tr),
          ),
        ),
        if (gamebook.author.email != null)
          PopupMenuItem(
            value: 'contact',
            child: ListTile(
              leading: Icon(Icons.email, size: 20),
              title: Text('contact_author'.tr),
            ),
          ),
      ],
    );
  }

  void _handleInfoMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'details':
        Get.toNamed('${AppRoutes.scenario}/${gamebook.id}',
            arguments: gamebook);
        onScenarioSelected();
        break;
      // case 'contact':
      //   _contactAuthor(gamebook.author);
      //   break;
    }
  }

// Enhanced Author Info Section
  Widget _buildAuthorAvatar(ThemeData theme, Author author) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: theme.colorScheme.secondaryContainer,
      foregroundImage:
          author.photoUrl != null ? NetworkImage(author.photoUrl!) : null,
      child: author.photoUrl == null
          ? Text(
              author.login?.isNotEmpty ?? false
                  ? author.login![0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
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
        child: gamebook.photoUrl != null
            ? Image.network(
                gamebook.photoUrl!,
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
