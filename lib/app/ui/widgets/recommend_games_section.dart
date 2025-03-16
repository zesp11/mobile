// Suggests games based on user preferences.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:gotale/app/ui/widgets/section_widget.dart';

class RecommendedGamesWidget extends StatelessWidget {
  final GameSelectionController controller = Get.find();

  RecommendedGamesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWidget(
      title: "recommended_games".tr,
      child: Obx(() {
        if (controller.isAvailableGamebooksLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.secondary,
            ),
          );
        }

        if (controller.availableGamebooks.isEmpty) {
          return Center(
            child: Text(
              "no_recommended_games".tr,
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return Column(
          children: controller.availableGamebooks.map((gamebook) {
            return Container(
              height: 90,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.tertiary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                elevation: theme.cardTheme.elevation ?? 1,
                color: theme.cardTheme.color,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Get.toNamed('/scenario/${gamebook.id}'),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: theme.colorScheme.secondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title and Rating
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gamebook.name,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: theme.colorScheme.secondary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "9.1",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Arrow aligned with title
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: theme.colorScheme.tertiary
                                      .withOpacity(0.6),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
