import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  // Get the controller instance
  final ProfileController controller =
      Get.put(ProfileController(userService: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (controller.userProfile.value == null) {
            return const CircularProgressIndicator();
          }

          final userProfile = controller.userProfile.value!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display a CircleAvatar with a placeholder if avatar is not available
              CircleAvatar(
                radius: 60,
                backgroundImage: userProfile.avatar.isNotEmpty
                    ? NetworkImage(userProfile.avatar)
                    : null, // Only load image if avatar is not empty
                child: userProfile.avatar.isEmpty
                    ? const Icon(Icons.person,
                        size: 60,
                        color: Colors.white) // Default icon if no avatar
                    : null, // If avatar exists, no icon will be shown
              ),
              const SizedBox(height: 20),
              Text(
                userProfile.name,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                userProfile.email,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                userProfile.bio,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Games Played: ${userProfile.gamesPlayed}",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                "Games Finished: ${userProfile.gamesFinished}",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.updateProfile('Jane Doe', 20, 15);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile updated!")),
                  );
                },
                child: const Text("Edit Profile"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
