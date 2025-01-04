import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/routes/app_routes.dart';

// card on click should redirect to main page of given gamebook
class GameSelectionScreen extends StatelessWidget {
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;
  final GameController gameController = Get.find();

  GameSelectionScreen(
      {required this.onGameSelected, required this.onScenarioSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Gamebook'),
        centerTitle: true,
      ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start: ${gamebook.startDate.toLocal()}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    if (gamebook.endDate != null)
                                      Text(
                                        'End: ${gamebook.endDate!.toLocal()}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        print("Go to scenario ${gamebook.id}");
                                        // TODO: span the statemanagement
                                        // DRY...
                                        Get.toNamed(
                                            '${AppRoutes.scenario}/${gamebook.id}');
                                        onScenarioSelected();
                                      },
                                      child: const Text('Desc'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        gameController
                                            .fetchGamebookData(gamebook.id);
                                        onGameSelected();
                                      },
                                      child: const Text('Select'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
}
