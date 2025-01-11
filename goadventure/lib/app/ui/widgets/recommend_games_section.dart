// Suggests games based on user preferences.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/ui/widgets/section_widget.dart';

class RecommendedGamesWidget extends StatelessWidget {
  final GameController controller = Get.find();

  RecommendedGamesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      title: "Recommended Games",
      child: Obx(() {
        if (controller.isAvailableGamebooksLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.availableGamebooks.isEmpty) {
          return const Center(
            child: Text(
              "No recommended games available.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: controller.availableGamebooks.map((gamebook) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              elevation: 3,
              child: SizedBox(
                height: 100, // Fixed height for all cards
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.gamepad, // Improved icon
                        color: Colors.blueAccent,
                        size: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gamebook.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              // "Rating: ${gamebook.rating.toStringAsFixed(1)}",
                              "Rating: ${9.1}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_forward, color: Colors.grey),
                        onPressed: () {
                          Get.toNamed('/scenario/${gamebook.id}');
                        },
                      ),
                    ],
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
