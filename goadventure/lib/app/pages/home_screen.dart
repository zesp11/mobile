import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  // Initialize the HomeController
  final HomeController controller =
      Get.put(HomeController(homeService: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Resume Last Game
            Obx(() {
              if (controller.lastGame.value != null) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    color: Colors.blueAccent,
                    child: ListTile(
                      leading: const Icon(Icons.play_arrow,
                          size: 40, color: Colors.white),
                      title: Text(
                        controller.lastGame.value!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Started: ${controller.lastGame.value!.startDate.toLocal()}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          if (controller.lastGame.value!.endDate != null)
                            Text(
                              "Ended: ${controller.lastGame.value!.endDate!.toLocal()}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          Text(
                            "Steps: ${controller.lastGame.value!.steps.length}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      onTap: controller.resumeLastGame,
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            const Divider(),
            // Section: Nearby Games
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Nearby Games',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(() {
              return Column(
                children: controller.nearbyGames.map((game) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.location_on,
                          color: Colors.redAccent, size: 30),
                      title: Text(
                        game.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: ${game.name}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "Started: ${game.startDate.toLocal()}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          if (game.endDate != null)
                            Text(
                              "Ended: ${game.endDate!.toLocal()}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          Text(
                            "Steps: ${game.steps.length}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => controller.startNewGame(game),
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
