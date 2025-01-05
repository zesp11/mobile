import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/routes/app_routes.dart';

// card on click should redirect to main page of given gamebook

// TODO: Make button that allows playing disabled, until user is logged in
// TODO: specify in one place prodcted routes
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

                return ListView.builder(
                  itemCount: gameController.availableGamebooks.length,
                  itemBuilder: (context, index) {
                    final gamebook = gameController.availableGamebooks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gamebook.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              gamebook.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // The "Desc" button should always be accessible
                                    Get.toNamed(
                                        '${AppRoutes.scenario}/${gamebook.id}',
                                        arguments: gamebook);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, // Smaller vertical padding
                                      horizontal:
                                          16.0, // Smaller horizontal padding
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text(
                                    'Desc',
                                    style: const TextStyle(
                                      fontSize: 14, // Smaller font size
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: authController.isAuthenticated
                                      ? () {
                                          final gamebookRoute =
                                              AppRoutes.gameDetail.replaceFirst(
                                                  ':id',
                                                  gamebook.id.toString());
                                          Get.toNamed(gamebookRoute);
                                        }
                                      : () => _showLoginDialog(context),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, // Smaller vertical padding
                                      horizontal:
                                          16.0, // Smaller horizontal padding
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    backgroundColor: authController
                                            .isAuthenticated
                                        ? Colors.blue
                                        : Colors.blue.withOpacity(
                                            0.5), // Maintain blue color with reduced opacity
                                  ),
                                  child: Text(
                                    'Select',
                                    style: const TextStyle(
                                      fontSize: 14, // Smaller font size
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a login dialog
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please Log In'),
          content: const Text('You need to log in to play the game.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                // Optionally, you can navigate to the login screen here
                Get.toNamed(AppRoutes.profile);
              },
              child: const Text('Log In'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
