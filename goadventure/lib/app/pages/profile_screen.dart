import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  // final ProfileController controller =
  //     Get.put(ProfileController(userService: Get.find()));
  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
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
              Text("Games Finished: ${userProfile.gamesFinished}",
                  style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.toNamed('/profile/edit'),
                child: const Text("Edit Profile"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
