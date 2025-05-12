import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/models/choice.dart';
import 'package:gotale/app/models/game_step.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:gotale/app/services/location_service.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

class ScenarioScreen extends StatelessWidget {
  final GameService service = Get.find<GameService>();
  final authController = Get.find<AuthController>();
  final LocationService locationService = Get.find<LocationService>();

  @override
  Widget build(BuildContext context) {
    final String id = Get.parameters['id']!;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: FutureBuilder<Scenario>(
        future: service.fetchScenarioDetails(int.parse(id)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'loading_scenario'.tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'error_loading_scenario'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onSecondary,
                      ),
                      label: Text('go_back'.tr),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'no_scenario_found'.tr,
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          final gamebook = snapshot.data!;

          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: theme.colorScheme.surface,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        gamebook.name ?? 'Untitled Gamebook',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: gamebook.photoUrl != null
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          shadows: gamebook.photoUrl != null
                              ? [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 1),
                                    blurRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      background: _buildAppBarBackground(theme, gamebook),
                    ),
                  ),

                  // Content
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16.0 : size.width * 0.1,
                      vertical: 24.0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          _buildAuthorInfo(context, gamebook.author),
                          const SizedBox(height: 24),
                          _buildDescriptionSection(
                              context, gamebook.description),
                          const SizedBox(height: 24),
                          _buildGameBookInfo(context, gamebook),
                          const SizedBox(height: 24),
                          _buildJourneyInfo(context, gamebook.firstStep!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                8 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: authController.isAuthenticated
                          ? () async {
                              final gameController =
                                  Get.find<GamePlayController>();
                              await gameController
                                  .createGameFromScenario(gamebook.id);
                              final bool isMulti = gamebook.limitPlayers > 1;
                              gameController.gameType = 
                              isMulti ? GameType.multi : GameType.single;

                              Get.toNamed(AppRoutes.gameDetail.replaceFirst(
                                  ":id",
                                  gameController.currentGame.value!.idGame
                                      .toString()));
                            }
                          : null,
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: 24,
                        color: authController.isAuthenticated
                            ? theme.colorScheme.onSecondary
                            : theme.colorScheme.onSurface.withOpacity(0.38),
                      ),
                      label: Text(
                        gamebook.limitPlayers > 1 ? 'create_lobby'.tr : 'play_game'.tr,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: authController.isAuthenticated
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.surfaceVariant,
                      ),
                    ),
                  ),
                  if (!authController.isAuthenticated)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'login_needed'.tr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuthorInfo(BuildContext context, Author author) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat.yMMMd().format(author.creationDate);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/profile/${author.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildAuthorAvatar(theme, author),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAuthorName(theme, author),
                    if (author.bio != null && author.bio!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          author.bio!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Member since $formattedDate',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorAvatar(ThemeData theme, Author author) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
      foregroundImage:
          author.photoUrl != null ? NetworkImage(author.photoUrl!) : null,
      child: author.photoUrl == null
          ? Icon(
              Icons.person,
              color: theme.colorScheme.secondary,
              size: 24,
            )
          : null,
    );
  }

  Widget _buildAuthorName(ThemeData theme, Author author) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          author.login ?? 'Anonymous',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        // Text(
        //   'ID: ${author.id}',
        //   style: theme.textTheme.bodySmall?.copyWith(
        //     color: theme.colorScheme.onSurface.withOpacity(0.6),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, String? description) {
    final theme = Theme.of(context);
    final hasDescription = description?.isNotEmpty ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.text_snippet_outlined,
                    size: 20,
                    // color: theme.colorScheme.onSurface.withOpacity(0.6),
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 8)),
                TextSpan(
                  text: 'description'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Text(
            hasDescription ? description! : 'no_description_available'.tr,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.4,
              color: hasDescription
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.left,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildGameBookInfo(BuildContext context, Scenario gamebook) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat.yMMMd(); // Formats to "Jul 12, 2023"

    return Card(
      elevation: 0,
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
            _buildSectionHeader(theme, 'game_info'.tr),
            const SizedBox(height: 16),
            Row(
              children: [
                // Creation Date Section
                Expanded(
                  child: _buildInfoItem(
                    context,
                    icon: Icons.calendar_today,
                    label: 'created'.tr,
                    value: dateFormatter.format(gamebook.creationDate),
                  ),
                ),
                // Players Section
                Expanded(
                  child: _buildInfoItem(
                    context,
                    icon: Icons.people_alt_outlined,
                    label: 'max_players'.tr,
                    value: gamebook.limitPlayers == 0
                        ? 'no_limit'.tr
                        : '${gamebook.limitPlayers}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String text) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 20,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJourneyInfo(BuildContext context, GameStep step) {
    final theme = Theme.of(context);
    final hasLocation = step.latitude != null && step.longitude != null;
    final hasChoices = step.choices.isNotEmpty;

    final logger = Get.find<Logger>();
    logger.d('step: lat=${step.latitude}, long=${step.longitude}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flag_circle_outlined,
              color: theme.colorScheme.secondary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'your_journey_begins_here'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
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
                // Step Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          theme.colorScheme.secondary.withOpacity(0.1),
                      child: Icon(
                        Icons.arrow_circle_right,
                        color: theme.colorScheme.secondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title ?? 'first_step'.tr,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'ID: ${step.id}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Step Content
                if (step.text?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      step.text!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.4,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),

                // Location Info
                if (hasLocation)
                  FutureBuilder<String>(
                    future: locationService.getPlaceName(
                      LatLng(step.latitude!, step.longitude!),
                    ),
                    builder: (context, snapshot) {
                      String text;
                      IconData icon;
                      Color color = theme.colorScheme.secondary;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        text = 'loading_location'.tr;
                        icon = Icons.hourglass_top;
                      } else if (snapshot.hasError) {
                        text = 'location_unavailable'.tr;
                        icon = Icons.error_outline;
                        color = theme.colorScheme.error;
                      } else {
                        text = snapshot.data ?? 'location_unavailable'.tr;
                        icon = Icons.location_pin;
                      }

                      return _buildInfoChip(
                        context,
                        icon: icon,
                        text: text,
                        color: color,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _buildAppBarBackground(ThemeData theme, Scenario gamebook) {
    if (gamebook.photoUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            gamebook.photoUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildFallbackBackground(theme),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return _buildFallbackBackground(theme);
  }

  Widget _buildFallbackBackground(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_stories,
          size: 64,
          color: theme.colorScheme.onPrimary.withOpacity(0.8),
        ),
      ),
    );
  }
}
