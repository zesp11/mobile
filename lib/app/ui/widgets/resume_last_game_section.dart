import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:gotale/app/models/game_in_progress.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/services/location_service.dart';
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

  Widget _buildGameSection(GameInProgress lastGame, BuildContext context) {
    final formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(lastGame.startTime);
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
              onTap: () {
                Get.toNamed(
                  AppRoutes.gameDetail
                      .replaceFirst(':id', lastGame.idGame.toString()),
                );
              },
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
                      'started_on'.trParams({'date': formattedDate}),
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
