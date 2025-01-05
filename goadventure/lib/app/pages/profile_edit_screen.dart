import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';

class ProfileEditScreen extends StatelessWidget {
  final ProfileController controller =
      Get.put(ProfileController(userService: Get.find()));

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Center(
        child: Obx(() {
          final userProfile = controller.userProfile.value;
          if (userProfile == null) {
            return const CircularProgressIndicator();
          }

          nameController.text = userProfile.name;
          bioController.text = userProfile.bio;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final gamesFinished = 0;
                    controller.updateProfile(
                      nameController.text,
                      int.parse(bioController.text),
                      gamesFinished,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile updated!")),
                    );
                  },
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
