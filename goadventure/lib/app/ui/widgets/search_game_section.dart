// New Section with Button for Navigating to Search Games Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/ui/widgets/section_widget.dart';
import 'package:goadventure/app/routes/app_routes.dart';

class SearchGamesSection extends StatelessWidget {
  const SearchGamesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      title: "Search Games",
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.gamepad_outlined,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 10),
            const Text(
              "Discover New Adventures!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Explore a vast collection of games and scenarios. Dive into unique storylines and find your next favorite game.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Use GetRouterOutletDelegate to update the content in the current layout
                Get.rootDelegate.toNamed(AppRoutes.search);
              },
              icon: const Icon(Icons.search, size: 24),
              label: const Text(
                "Find Games",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
