import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:gotale/app/models/game_in_progress.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:gotale/app/services/location_service.dart';
import 'package:gotale/app/ui/pages/lobby_screen.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:latlong2/latlong.dart';

class ResumeLastGameSection extends GetView<GameSelectionController> {
  final LocationService locationService = Get.find<LocationService>();

  ResumeLastGameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (games) => _buildGameSection(games!.first, context),
      onLoading: _buildSkeleton(context),
      onEmpty: const SizedBox.shrink(),
      onError: (error) => Card(
        child: ListTile(
          leading: const Icon(Icons.error, color: Colors.red),
          title: Text('Error loading games'.tr),
          subtitle: Text(error!),
        ),
      ),
    );
  }
  
  Future<void> _handleGameTap(GameInProgress lastGame, BuildContext context) async {
    final apiService = Get.find<ApiService>();
    final secureStorage = Get.find<FlutterSecureStorage>();
    
    try {
      final token = await secureStorage.read(key: 'accessToken');
      final jwtToken = token != null ? 'Bearer $token' : "null";
      
      final scenario = await apiService.getScenarioWithId(lastGame.idScen);
      
      final isMultiplayer = scenario.limitPlayers > 1;

      if(isMultiplayer) {
        
        final lobby = await apiService.getLobbyWithIdGame(lastGame.idGame);

        if (lobby.status == "Waiting for more players") {
          Get.to(() => LobbyScreen(
            gamebook: scenario,
            jwtToken: jwtToken,
            type: "rejoin-waiting",
            id: lobby.idLobby,
            gameId: lastGame.idGame,
          ));
        } else if (lobby.status == "Gaming") {
          Get.to(() => LobbyScreen(
            gamebook: scenario,
            jwtToken: jwtToken,
            type: "rejoin",
            id: lobby.idLobby,
            gameId: lastGame.idGame,
          ));
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              final theme = Theme.of(context);
              return AlertDialog(
                backgroundColor: theme.colorScheme.primary,
                title: Text(
                  'cant_return_to_lobby'.tr,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                content: Text(
                  'cant_lobby_explanation'.tr,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        Get.toNamed(
          AppRoutes.gameDetail
              .replaceFirst(':id', lastGame.idGame.toString()),
        );
      }
    } catch (e) {
      // Handle error case
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading game data: $e')),
      );
    }
  }

  Widget _buildGameSection(GameInProgress lastGame, BuildContext context) {
    final formattedDate =
        DateFormat('d MMMM yyyy HH:mm', 'pl').format(lastGame.startTime);
    final location =
        LatLng(lastGame.currentStep.latitude, lastGame.currentStep.longitude);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'resume_last_game'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Card(
            child: InkWell(
              onTap: () => _handleGameTap(lastGame, context),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '(${lastGame.idGame}) ${lastGame.scenarioName}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${"started_on".tr} $formattedDate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lastGame.currentStep.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<String>(
                      future: locationService.getPlaceName(location),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 2,
                            child: LinearProgressIndicator(),
                          );
                        }

                        final locationText = snapshot.data ??
                            locationService.formatCoordinates(location);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  locationText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle_outline), // Skeletonized icon
                const SizedBox(width: 8),
                Container(
                  width: 150,
                  height: 24,
                  color: Colors.grey.shade300, // Skeleton placeholder
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 20,
                            color: Colors.grey.shade800, // Skeleton placeholder
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 16,
                          height: 16,
                          color: Colors.grey.shade300, // Skeleton placeholder
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 16,
                      color: Colors.grey.shade300, // Skeleton placeholder
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
