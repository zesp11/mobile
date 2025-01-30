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
      title: "search_games".tr,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFA802F), // Accent color
              const Color(0xFFFA802F).withOpacity(0.8), // Lighter accent
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFF9C8B73).withOpacity(0.2), // Secondary color
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
            Icon(
              Icons.gamepad_outlined,
              color: const Color(0xFFF3E8CA), // Background color
              size: 60,
            ),
            const SizedBox(height: 10),
            Text(
              "discover_adventures".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF3E8CA), // Background color
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "explore_games".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFFF3E8CA)
                    .withOpacity(0.9), // Background color
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Get.rootDelegate.toNamed(AppRoutes.search);
              },
              icon: Icon(Icons.search,
                  size: 24, color: const Color(0xFF322505)), // Foreground
              label: Text(
                "find_games".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF322505), // Foreground
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3E8CA), // Background
                foregroundColor: const Color(0xFF322505), // Foreground
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color:
                        const Color(0xFF322505).withOpacity(0.3), // Foreground
                    width: 1,
                  ),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
