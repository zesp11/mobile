import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:intl/intl.dart';

Widget buildScenarioCard(ThemeData theme, Scenario scenario) {
  final timeago = DateFormat('MMM dd, yyyy').format(scenario.creationDate);

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: InkWell(
      onTap: () => Get.toNamed('/scenario/${scenario.id}'),
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 120, // Fixed card height
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Pane
            Container(
              width: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              child: (scenario.photoUrl != null && scenario.photoUrl!.isNotEmpty && Uri.tryParse(scenario.photoUrl!)?.isAbsolute == true)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: Image.network(
                          scenario.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.broken_image,
                              color: theme.colorScheme.secondary,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Icon(
                          Icons.auto_stories,
                          color: theme.colorScheme.secondary,
                          size: 36,
                        ),
                      ),
                    ),
            ),
            // Content Pane
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.name ?? 'Untitled Scenario',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scenario.description ?? 'No description provided',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.people_outline,
                          text: '${scenario.limitPlayers}',
                          theme: theme,
                        ),
                        const SizedBox(width: 12),
                        _buildInfoChip(
                          icon: Icons.calendar_today_outlined,
                          text: timeago,
                          theme: theme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildInfoChip({
  required IconData icon,
  required String text,
  required ThemeData theme,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
      const SizedBox(width: 4),
      Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    ],
  );
}
