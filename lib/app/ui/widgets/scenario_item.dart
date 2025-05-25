import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:skeletonizer/skeletonizer.dart';

// TODO: remove that unused class

class ScenarioCard extends StatelessWidget {
  final Scenario gamebook;
  final AuthController authController;
  final gamePlayController = Get.find<GamePlayController>();

  ScenarioCard({
    Key? key,
    required this.gamebook,
    required this.authController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(isDark ? 0.1 : 0.08),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Get.toNamed('${AppRoutes.scenario}/${gamebook.id}',
            arguments: gamebook),
        hoverColor: theme.colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full-width cover image
              _buildCoverImage(theme),
              const SizedBox(height: 20),

              // Responsive content layout
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool useCompactLayout = constraints.maxWidth < 600;

                  return useCompactLayout
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gamebook.name!,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoChips(context),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    gamebook.name!,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
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
                    height: 1.6,
                  ),
                  moreStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
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

  Widget _buildCoverImage(ThemeData theme) {
    return Container(
      width: double.infinity, // Full width
      height: 180, // Increased height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: gamebook.photoUrl != null
            ? Image.network(
                gamebook.photoUrl!,
                fit: BoxFit.cover, // Maintain aspect ratio while filling space
              )
            : Center(
                child: Icon(
                  Icons.auto_stories,
                  size: 40,
                  color: theme.colorScheme.tertiary.withOpacity(0.3),
                ),
              ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAuthorInfo(context, theme, gamebook.author, isDark),
        const SizedBox(height: 16),
        _buildPlayButton(context, theme, isDark),
      ],
    );
  }

  Widget _buildAuthorInfo(
      BuildContext context, ThemeData theme, Author author, bool isDark) {
    return Tooltip(
      message: author.bio ?? 'no_bio_available'.tr,
      child: GestureDetector(
        onTap: () => Get.toNamed('/profile/${author.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary.withOpacity(isDark ? 0.15 : 0.1),
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.tertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormat.yMMMd('pl').format(author.creationDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.tertiary.withOpacity(0.8),
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

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120),
      /*child: ElevatedButton.icon(
        icon: Icon(
          canPlay ? Icons.play_arrow_rounded : Icons.error_outline,
          size: 20,
        ),
        label: Text(canPlay ? 'play'.tr : 'not_ready'.tr),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: canPlay ? 1 : 0,
          backgroundColor: canPlay
              ? theme.colorScheme.secondary
              : theme.colorScheme.tertiary.withOpacity(0.1),
          foregroundColor: canPlay
              ? theme.colorScheme.onSecondary
              : theme.colorScheme.tertiary,
        ),
        onPressed: canPlay
            ? () async {
                final gameController = Get.find<GamePlayController>();
                await gameController.createGameFromScenario(gamebook.id);
                Get.toNamed(AppRoutes.gameDetail.replaceFirst(":id",
                    gameController.currentGame.value!.idGame.toString()));
              }
            : () => _handlePlayRestriction(context, canPlay),
      ),*/
    );
  }

  Widget _buildInfoChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildInfoChip(
          context,
          icon: Icons.people_outline,
          label: '${gamebook.limitPlayers} ${"players".tr}',
        ),
        _buildInfoChip(
          context,
          icon: Icons.calendar_today_outlined,
          label: DateFormat.yMMMMd('pl').format(gamebook.creationDate),
        ),
      ],
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String label}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withOpacity(isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

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
