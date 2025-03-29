import 'package:flutter/material.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/scenario_controller.dart';
import 'package:gotale/app/ui/widgets/scenario_item.dart';
import 'package:gotale/app/ui/widgets/scenario_list.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final authController = Get.find<AuthController>();

    return DefaultTabController(
      length: authController.isAuthenticated ? 2 : 1,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: theme.colorScheme.secondary,
          labelColor: theme.colorScheme.secondary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.7),
          labelStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: theme.textTheme.titleMedium,
          indicatorWeight: 3,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: 'scenarios'.tr),
            if (authController.isAuthenticated)
              Tab(text: 'games_in_progress'.tr),
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _ScenariosTab(
                isSmallScreen: isSmallScreen,
                size: size,
              ),
              if (authController.isAuthenticated)
                _GamesInProgressTab(isSmallScreen: isSmallScreen, size: size),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScenariosTab extends GetView<ScenarioController> {
  final bool isSmallScreen;
  final Size size;

  const _ScenariosTab({
    required this.isSmallScreen,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16.0 : size.width * 0.1,
        vertical: 16.0,
      ),
      child: controller.obx(
        (scenarios) => ScenarioListView(
          gamebooks: scenarios!,
          authController: authController,
        ),
        onLoading: ScenariosTabSkeleton(),
        onEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 64,
                color: theme.colorScheme.onBackground.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'no_gamebooks_available'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        onError: (error) => Center(
          child: Text(error!,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.error)),
        ),
      ),
    );
  }
}

class ScenariosTabSkeleton extends StatelessWidget {
  const ScenariosTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 4,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ScenarioCardSkeleton(),
        ),
      ),
    );
  }
}

class ScenarioCardSkeleton extends StatelessWidget {
  const ScenarioCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loading Scenario Title',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Loading scenario description placeholder text',
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Skeleton.replace(
                  child: Container(
                    width: 80,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Skeleton.replace(
                  child: Container(
                    width: 100,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Skeleton.replace(
                  child: Container(
                    width: 80,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Skeleton.replace(
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GamesInProgressTab extends GetView<GameSelectionController> {
  final bool isSmallScreen;
  final Size size;

  const _GamesInProgressTab({
    required this.isSmallScreen,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy - HH:mm');

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16.0 : size.width * 0.1,
        vertical: 16.0,
      ),
      child: controller.obx(
        (games) => ListView.separated(
          itemCount: games!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final game = games[index];
            final startTime = game.startTime.toLocal();

            return Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Get.toNamed(
                  AppRoutes.gameDetail
                      .replaceFirst(':id', game.idGame.toString()),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              game.scenarioName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onBackground,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Chip(
                            backgroundColor:
                                theme.colorScheme.secondary.withOpacity(0.1),
                            label: Text(
                              '#${game.idGame}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildGameInfoRow(
                        context,
                        icon: Icons.timelapse_outlined,
                        label: 'Started ${dateFormat.format(startTime)}',
                      ),
                      _buildGameInfoRow(
                        context,
                        icon: Icons.article_outlined,
                        label: 'Current Step: ${game.currentStep}',
                      ),
                      if (game.currentStepText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            game.currentStepText,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.play_arrow, size: 20),
                          label: Text('continue_playing'.tr),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => Get.toNamed(
                            AppRoutes.gameDetail
                                .replaceFirst(':id', game.idGame.toString()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        onLoading: const GamesInProgressSkeleton(),
        onEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_esports_outlined,
                size: 64,
                color: theme.colorScheme.tertiary,
              ),
              const SizedBox(height: 16),
              Text(
                'no_games_in_progress'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        onError: (error) => Center(
          child: Text(error!,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.error)),
        ),
      ),
    );
  }

  Widget _buildGameInfoRow(BuildContext context,
      {required IconData icon, required String label}) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.tertiary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class GamesInProgressSkeleton extends StatelessWidget {
  const GamesInProgressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Scenario Name Loading',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Chip(
                        backgroundColor:
                            theme.colorScheme.secondary.withOpacity(0.1),
                        label: Text(
                          '#000',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSkeletonInfoRow(context),
                  _buildSkeletonInfoRow(context),
                  const SizedBox(height: 8),
                  Text(
                    'Current step text loading',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow, size: 20),
                      label: Text('continue_playing'.tr),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
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

  Widget _buildSkeletonInfoRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.timelapse_outlined, size: 16),
          const SizedBox(width: 8),
          Text(
            'Loading information...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
