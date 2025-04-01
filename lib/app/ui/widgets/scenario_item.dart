import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScenarioListItem extends StatelessWidget {
  final Scenario gamebook;
  final AuthController authController;
  final gamePlayController = Get.find<GamePlayController>();

  ScenarioListItem({
    Key? key,
    required this.gamebook,
    required this.authController,
  }) : super(key: key);

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAuthorInfo(context, theme, gamebook.author),
        const SizedBox(height: 16),
        _buildPlayButton(context, theme, isDark),
      ],
    );
  }

  Widget _buildAuthorInfo(
      BuildContext context, ThemeData theme, Author author) {
    return Tooltip(
      message: author.bio ?? 'no_bio_available'.tr,
      child: GestureDetector(
        onTap: () => Get.toNamed('/profile/${author.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAuthorAvatar(theme, author),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author.login ?? 'Anonymous',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Created ${DateFormat.yMMMd().format(author.creationDate)}',
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

  Widget _buildPlayButton(BuildContext context, ThemeData theme, bool isDark) {
    final canPlay = authController.isAuthenticated;

    return ElevatedButton.icon(
      icon: Icon(
        canPlay ? Icons.play_arrow_rounded : Icons.lock_outline,
        size: 24,
      ),
      label: Text(
        canPlay ? 'start_adventure'.tr : 'login_to_play'.tr,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: canPlay
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceVariant,
        foregroundColor: canPlay
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant,
        elevation: 2,
        shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      ),
      onPressed: canPlay
          ? () async {
              final gameController = Get.find<GamePlayController>();
              await gameController.createGameFromScenario(gamebook.id);
              Get.toNamed(AppRoutes.gameDetail.replaceFirst(
                  ":id", gameController.currentGame.value!.idGame.toString()));
            }
          : () => _handlePlayRestriction(context, canPlay),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.08),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Get.toNamed(
          '${AppRoutes.scenario}/${gamebook.id}',
          arguments: gamebook,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool useCompactLayout = constraints.maxWidth < 500;

                  return useCompactLayout
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCoverImage(theme),
                            const SizedBox(height: 20),
                            _buildContent(theme),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCoverImage(theme),
                            const SizedBox(width: 24),
                            Expanded(child: _buildContent(theme)),
                          ],
                        );
                },
              ),
              if (gamebook.description != null) ...[
                const SizedBox(height: 20),
                Text(
                  gamebook.description!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    height: 1.6,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 24),
              _buildActionButtons(context, theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gamebook.name!,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        _buildInfoChips(theme),
      ],
    );
  }

  Widget _buildInfoChips(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildInfoChip(
          icon: Icons.people_alt_outlined,
          label: '${gamebook.limitPlayers} Players',
          theme: theme,
        ),
        _buildInfoChip(
          icon: Icons.schedule_outlined,
          label: '${gamebook.creationDate} mins',
          theme: theme,
        ),
        // _buildInfoChip(
        //   icon: Icons.calendar_month_outlined,
        //   label: DateFormat('MMM dd, yyyy').format(gamebook.creationDate),
        //   theme: theme,
        // ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.secondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(ThemeData theme) {
    return Hero(
      tag: 'scenario-cover-${gamebook.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 120,
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.surfaceVariant.withOpacity(0.4),
                theme.colorScheme.surfaceVariant.withOpacity(0.1),
              ],
            ),
          ),
          child: gamebook.photoUrl != null
              ? Image.network(gamebook.photoUrl!, fit: BoxFit.cover)
              : Center(
                  child: Icon(
                    Icons.auto_stories_outlined,
                    size: 40,
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
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
        },
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
