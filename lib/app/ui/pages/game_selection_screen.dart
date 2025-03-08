import 'package:flutter/material.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:gotale/app/ui/widgets/gamebook_list.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'game_selection'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
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
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
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
      ),
    );
  }
}
