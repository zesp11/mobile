// Suggests games based on user preferences.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/scenario_controller.dart';
import 'package:gotale/app/ui/widgets/scenario_card.dart';
import 'package:gotale/app/ui/widgets/section_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecommendedScenariosWidget extends GetView<ScenarioController> {
  const RecommendedScenariosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWidget(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'recommended_scenarios'.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          controller.obx(
            (scenarios) => Column(
              children: scenarios!.take(5).map((scenario) {
                return buildScenarioCard(theme, scenario);
              }).toList(),
            ),
            onLoading: _buildSkeletonList(context),
            onEmpty: Center(
              child: Text(
                "no_recommended_games".tr,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList(BuildContext context) {
    return Column(
      children: List.generate(
        4, // Show up to 4 skeleton items
        (index) => Container(
          height: 90,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                width: 1,
              ),
            ),
            elevation: Theme.of(context).cardTheme.elevation ?? 1,
            color: Theme.of(context).cardTheme.color,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    // Skeleton for Icon Container
                    Skeletonizer(
                      enabled: true,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Skeleton for Title and Rating
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Skeletonizer(
                                  enabled: true,
                                  child: Container(
                                    height: 20,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Skeletonizer(
                                      enabled: true,
                                      child: Container(
                                        height: 16,
                                        width: 30,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Skeleton for Arrow icon
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Skeletonizer(
                              enabled: true,
                              child: Container(
                                height: 24,
                                width: 24,
                                color: Colors.grey[300],
                              ),
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
        ),
      ),
    );
  }
}
