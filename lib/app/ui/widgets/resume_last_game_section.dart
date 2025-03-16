import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:gotale/app/routes/app_routes.dart';

class ResumeLastGameSection extends StatelessWidget {
  final GameSelectionController controller = Get.find();

  ResumeLastGameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isGamesInProgressLoading.value) {
        return const SizedBox.shrink();
      }

      if (controller.gamesInProgress.isEmpty) {
        return const SizedBox.shrink();
      }

      // Get the most recent game
      final lastGame = controller.gamesInProgress.first;
      final startTime = lastGame.startTime;
      final formattedDate =
          '${startTime.day}/${startTime.month}/${startTime.year}';

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
            const SizedBox(height: 12),
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
                        'started_on'.trParams({
                          'date': formattedDate,
                        }),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
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
    });
  }
}
