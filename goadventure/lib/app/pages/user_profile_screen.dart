import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:get/get.dart';

class UserProfileScreen extends StatelessWidget {
  final ProfileController controller =
      Get.put(ProfileController(userService: Get.find()));

  // TODO: redirect to /profile if its user own profile
  @override
  Widget build(BuildContext context) {
    final String userId = Get.parameters['id']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: Center(
        child: FutureBuilder(
          // Assume this method fetches profile by ID
          future: controller.fetchUserProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            // Check if userProfile is null before accessing its properties
            final userProfile = controller.userProfile.value;

            // If userProfile is null, return a placeholder
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
                // Ensure that `gamesFinished` can be safely accessed
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
