import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  // Get the controller instance
  final ProfileController controller =
      Get.put(ProfileController(apiService: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Observing userName with GetX
            Obx(() {
              return Text(
                controller.userName.value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
            const SizedBox(
              height: 10,
            ),
            // Observing gamesPlayed and gamesFinished with GetX
            Obx(() {
              return Text(
                "Games Played: ${controller.gamesPlayed.value}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              );
            }),
            const SizedBox(
              height: 5,
            ),
            Obx(() {
              return Text(
                "Games Finished: ${controller.gamesFinished.value}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              );
            }),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // Here you can update the profile as an example
                controller.updateProfile('Jane Doe', 20, 15);

                // Show a snack bar as feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile updated!"),
                  ),
                );
              },
              child: const Text("Edit Profile"),
            )
          ],
        ),
      ),
    );
  }
}
