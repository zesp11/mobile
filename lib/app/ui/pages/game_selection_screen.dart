import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/scenario_controller.dart';
import 'package:gotale/app/models/game_in_progress.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/lobby_light.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:gotale/app/ui/pages/lobby_screen.dart';
import 'package:gotale/app/ui/widgets/scenario_list.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:latlong2/latlong.dart';
import 'package:gotale/app/services/location_service.dart';

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
      child: RefreshIndicator(
        color: theme.colorScheme.secondary,
        backgroundColor: theme.colorScheme.primary,
        onRefresh: () async => await controller.fetchAvailableGamebooks(),
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
  final LocationService locationService = Get.find<LocationService>();

  _GamesInProgressTab({
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
      child: Column(
        children: [
          Obx(() => CheckboxListTile(
                title: Text('include_finished_games'.tr),
                value: controller.includeFinished.value,
                onChanged: (value) => controller.toggleIncludeFinished(value!),
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              )),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              color: theme.colorScheme.secondary,
              backgroundColor: theme.colorScheme.primary,
              onRefresh: () async => await controller.fetchGamesInProgress(),
              child: controller.obx(
                (games) => ListView.separated(
                  itemCount: games!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return _buildGameSection(game, context);
                  },
                ),
                onLoading: const GamesInProgressSkeleton(),
                onEmpty: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Center(
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
                  ],
                ),
                onError: (error) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Center(
                      child: Text(
                        error!,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameSection(GameInProgress lastGame, BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMMM yyyy - HH:mm', 'pl');
    final startTime = lastGame.startTime.toLocal();
    final location =
        LatLng(lastGame.currentStep.latitude, lastGame.currentStep.longitude);
    final apiService = Get.find<ApiService>();
    final authController = Get.find<AuthController>();

    final FlutterSecureStorage secureStorage = Get.find<FlutterSecureStorage>();
    late String jwtToken;

    Future<List<dynamic>> _loadAllData() async {
      final token = await secureStorage.read(key: 'accessToken');
      jwtToken = token != null ? 'Bearer $token' : "null";
      final scenario = await apiService.getScenarioWithId(lastGame.idScen);
      final lobby = await apiService.getLobbyWithIdGame(lastGame.idGame);
      return [scenario, lobby];
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        /*onTap: () => Get.toNamed(
          AppRoutes.gameDetail.replaceFirst(':id', lastGame.idGame.toString()),
        ),*/
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
                      lastGame.scenarioName,
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
                      '#${lastGame.idGame}',
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
                label: '${"started".tr} ${dateFormat.format(startTime)}',
              ),
              _buildGameInfoRow(
                context,
                icon: Icons.article_outlined,
                label: lastGame.currentStep.title,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FutureBuilder<String>(
                  future: locationService.getPlaceName(location),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 2,
                        child: LinearProgressIndicator(),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              snapshot.data ??
                                  locationService.formatCoordinates(location),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<dynamic>>(
                future: _loadAllData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.length != 2) {
                    return Text('Error while loading data', style: theme.textTheme.bodySmall);
                  }

                  final scenario = snapshot.data![0] as Scenario;
                  final lobby = snapshot.data![1] as LobbyLight;
                  final isMultiplayer = scenario.limitPlayers > 1;
                  return Align(
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
                      onPressed: () {
                        if(isMultiplayer && lobby.status == "Waiting for more players") {
                          Get.to(() => LobbyScreen(
                            gamebook: scenario,
                            jwtToken: jwtToken,
                            type: "rejoin-waiting",
                            id: lobby.idLobby,
                            gameId: lastGame.idGame,
                          ));
                            
                        } else if (isMultiplayer && lobby.status == "gaming"){
                          Get.to(() => LobbyScreen(
                            gamebook: scenario,
                            jwtToken: jwtToken,
                            type: "rejoin",
                            id: lobby.idLobby,
                            gameId: lastGame.idGame,
                          ));
                        
                        }else {
                          Get.toNamed(
                          AppRoutes.gameDetail
                              .replaceFirst(':id', lastGame.idGame.toString()),
                          );
                        }
                        
                      }
                    ),
                  );
                }
              
              )
            ],
          ),
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
