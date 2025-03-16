import 'package:flutter/material.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/scenario_controller.dart';
import 'package:gotale/app/ui/widgets/scenario_item.dart';
import 'package:gotale/app/ui/widgets/scenario_list.dart';
import 'package:gotale/app/routes/app_routes.dart';

class GameSelectionScreen extends StatelessWidget {
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;

  const GameSelectionScreen({
    required this.onGameSelected,
    required this.onScenarioSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final authController = Get.find<AuthController>();

    return DefaultTabController(
      length: authController.isAuthenticated ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            'game_selection'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
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
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _ScenariosTab(
                onGameSelected: onGameSelected,
                onScenarioSelected: onScenarioSelected,
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
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;
  final bool isSmallScreen;
  final Size size;

  const _ScenariosTab({
    required this.onGameSelected,
    required this.onScenarioSelected,
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
          onGameSelected: onGameSelected,
          onScenarioSelected: onScenarioSelected,
        ),
        onLoading: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) => const ScenarioCardSkeleton(),
        ),
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

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16.0 : size.width * 0.1,
        vertical: 16.0,
      ),
      child: controller.obx(
        (games) => ListView.builder(
          itemCount: games!.length,
          itemBuilder: (context, index) {
            final game = games[index];
            final startTime = DateTime.parse(game.startTime.toString());
            final formattedDate =
                '${startTime.day}/${startTime.month}/${startTime.year}';

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text('(${game.idGame}) ${game.scenarioName}'),
                subtitle: Text(
                  'started_on'.trParams({'date': formattedDate}),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.gameDetail
                          .replaceFirst(':id', game.idGame.toString()),
                    );
                  },
                ),
              ),
            );
          },
        ),
        onLoading: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.secondary),
              const SizedBox(height: 16),
              Text(
                'loading_games'.tr,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        onEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.games_outlined,
                size: 64,
                color: theme.colorScheme.onBackground.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'no_games_in_progress'.tr,
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
