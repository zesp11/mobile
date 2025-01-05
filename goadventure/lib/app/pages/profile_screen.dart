import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Obx(() {
        if (authController.isAuthenticated) {
          // User is authenticated, show the profile
          if (authController.userProfile.value != null) {
            final userProfile = authController.userProfile.value!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: userProfile.avatar.isNotEmpty
                        ? NetworkImage(userProfile.avatar)
                        : null,
                    child: userProfile.avatar.isEmpty
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.white)
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
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/profile/edit'),
                    child: const Text("Edit Profile"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => authController.logout(),
                    child: const Text("Logout"),
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator(); // Show loading spinner while fetching user profile
          }
        } else {
          // Show login screen or message if not authenticated
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Not Logged in",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: there should be middleware instead that causes redirect to /login
                    // Navigate to login page if not authenticated
                    // currently mock login
                    authController.login(
                        "this always work", "credentials dont matter");
                    // Get.toNamed(
                    //     '/login');
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
