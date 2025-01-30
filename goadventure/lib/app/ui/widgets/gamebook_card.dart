import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/routes/app_routes.dart';

class GamebookCard extends StatelessWidget {
  final Gamebook gamebook;
  final AuthController authController;

  GamebookCard({required this.gamebook, required this.authController});

  @override
  Widget build(BuildContext context) {
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
            GamebookButtons(
              gamebook: gamebook,
              authController: authController,
            ),
          ],
        ),
      ),
    );
  }
}

class GamebookButtons extends StatelessWidget {
  final Gamebook gamebook;
  final AuthController authController;

  GamebookButtons({required this.gamebook, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GamebookDescriptionButton(gamebook: gamebook),
        SizedBox(width: 10),
        GamebookSelectButton(
            gamebook: gamebook, authController: authController),
      ],
    );
  }
}

class GamebookDescriptionButton extends StatelessWidget {
  final Gamebook gamebook;

  GamebookDescriptionButton({required this.gamebook});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(
          '${AppRoutes.scenario}/${gamebook.id}',
          arguments: gamebook,
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Color(0xFFFA802F), // Accent color
      ),
      child: Icon(
        Icons.info_outline,
        color: Color(0xFFF3E8CA), // Background color
        size: 24,
      ),
    );
  }
}

class GamebookSelectButton extends StatelessWidget {
  final Gamebook gamebook;
  final AuthController authController;

  GamebookSelectButton({
    required this.gamebook,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: authController.isAuthenticated
          ? () {
              final gamebookRoute = AppRoutes.gameDetail
                  .replaceFirst(':id', gamebook.id.toString());
              Get.toNamed(gamebookRoute);
            }
          : () => _showLoginDialog(context),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: authController.isAuthenticated
            ? Color(0xFFFA802F) // Accent color
            : Color(0xFF9C8B73).withOpacity(0.3), // Secondary color
      ),
      child: Icon(
        Icons.play_arrow,
        color: authController.isAuthenticated
            ? Color(0xFFF3E8CA) // Background color
            : Color(0xFF9C8B73).withOpacity(0.6), // Secondary color
        size: 24,
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF3E8CA), // Background color
          title: Text(
            'Please Log In',
            style: TextStyle(color: Color(0xFF322505)), // Foreground color
          ),
          content: Text(
            'You need to log in to play the game.',
            style: TextStyle(color: Color(0xFF9C8B73)), // Secondary color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.toNamed(AppRoutes.profile);
              },
              child: Text(
                'Log In',
                style: TextStyle(color: Color(0xFFFA802F)), // Accent color
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF9C8B73)), // Secondary color
              ),
            ),
          ],
        );
      },
    );
  }
}
