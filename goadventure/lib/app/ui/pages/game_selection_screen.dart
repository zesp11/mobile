import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/ui/widgets/gamebook_list.dart';

class GameSelectionScreen extends StatelessWidget {
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;
  final GameSelectionController controller = Get.find();
  final authController = Get.find<AuthController>();

  GameSelectionScreen(
      {required this.onGameSelected, required this.onScenarioSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'available_gamebooks'.tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.isAvailableGamebooksLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.availableGamebooks.isEmpty) {
                  return Center(
                    child: Text('no_gamebooks_available'.tr),
                  );
                }

                return GamebookListView(
                  gamebooks: controller.availableGamebooks,
                  authController: authController,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
