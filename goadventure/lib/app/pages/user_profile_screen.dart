import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/pages/error_screen.dart';

// TODO: redirect to /profile if its user own profile, but using middleware
class UserProfileScreen extends GetView<ProfileController> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final String userId = Get.parameters['id']!;

    if (authController.userProfile.value?.id == userId) {
      // Redirect to the logged-in user's profile screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed('/profile');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: Center(
        child: controller.obx(
          // Handling different states using the `obx`
          onLoading:
              const CircularProgressIndicator(), // Show loading spinner while loading
          onError: (error) => ErrorScreen(
            error: error,
            onRetry: () {
              controller.fetchUserProfile(userId);
            },
          ), // Show error message
          onEmpty: const Text('User profile not found.'), // Fallback message
          (userProfile) {
            // If userProfile is successfully fetched
            if (userProfile == null) {
              return const Text('User profile not found.');
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: userProfile.avatar.isNotEmpty
                      ? NetworkImage(userProfile.avatar)
                      : null,
                  child: userProfile.avatar.isEmpty
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 20),
                Text(userProfile.name,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(userProfile.email,
                    style: const TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 10),
                Text(userProfile.bio,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text("Games Played: ${userProfile.gamesPlayed}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 5),
                Text(
                  "Games Finished: ${userProfile.gamesFinished ?? 'N/A'}", // Fallback to 'N/A' if gamesFinished is null
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
