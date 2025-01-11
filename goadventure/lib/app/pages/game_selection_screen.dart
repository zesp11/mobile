import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/pages/widgets/gamebook_list.dart';

class GameSelectionScreen extends StatelessWidget {
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;
  final GameController gameController = Get.find();
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
            const Text(
              'Available Gamebooks:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (gameController.isAvailableGamebooksLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (gameController.availableGamebooks.isEmpty) {
                  return const Center(
                    child: Text('No gamebooks available.'),
                  );
                }

                return GamebookListView(
                  gamebooks: gameController.availableGamebooks,
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
