import 'package:flutter/material.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:gotale/app/ui/widgets/gamebook_list.dart';
import 'package:gotale/app/routes/app_routes.dart';

class GameSelectionScreen extends StatelessWidget {
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;
  final GameSelectionController controller = Get.find();
  final authController = Get.find<AuthController>();

  GameSelectionScreen({
    required this.onGameSelected,
    required this.onScenarioSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isAuthenticated = authController.isAuthenticated;

    return DefaultTabController(
      length: isAuthenticated ? 2 : 1,
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
              if (isAuthenticated) Tab(text: 'games_in_progress'.tr),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              // Scenarios Tab
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : size.width * 0.1,
                  vertical: 16.0,
                ),
                child: Obx(() {
                  if (controller.isAvailableGamebooksLoading.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'loading_gamebooks'.tr,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.availableGamebooks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 64,
                            color:
                                theme.colorScheme.onBackground.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'no_gamebooks_available'.tr,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return GamebookListView(
                    gamebooks: controller.availableGamebooks,
                    authController: authController,
                    onGameSelected: onGameSelected,
                    onScenarioSelected: onScenarioSelected,
                  );
                }),
              ),
              // Games in Progress Tab (only shown when authenticated)
              if (isAuthenticated)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16.0 : size.width * 0.1,
                    vertical: 16.0,
                  ),
                  child: Obx(() {
                    if (controller.isGamesInProgressLoading.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'loading_games'.tr,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.gamesInProgress.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.games_outlined,
                              size: 64,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'no_games_in_progress'.tr,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.gamesInProgress.length,
                      itemBuilder: (context, index) {
                        final game = controller.gamesInProgress[index];
                        final startTime =
                            DateTime.parse(game.startTime.toString());
                        final formattedDate =
                            '${startTime.day}/${startTime.month}/${startTime.year}';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title:
                                Text('(${game.idGame}) ${game.scenarioName}'),
                            subtitle: Text(
                              'started_on'.trParams({
                                'date': formattedDate,
                              }),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () {
                                Get.toNamed(
                                  AppRoutes.gameDetail.replaceFirst(
                                      ':id', game.idGame.toString()),
                                );
                                onGameSelected();
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
