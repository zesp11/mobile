import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  // Initialize the HomeController
  final HomeController controller =
      Get.put(HomeController(apiService: Get.find()));

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
                        controller.lastGame.value!['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Continue: ${controller.lastGame.value!['progress']}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      onTap: controller.resumeLastGame,
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
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
                        game['title']!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Distance: ${game['distance']}"),
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
