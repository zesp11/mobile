import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/pages/widgets/user_profile.dart';
import 'package:goadventure/app/pages/widgets/user_profile_actions.dart';

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
          final userProfile = authController.userProfile.value;
          if (userProfile != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserProfileWidget(userProfile: userProfile),
                  const SizedBox(height: 20),
                  UserActionsWidget(
                    onEditProfile: () => Get.toNamed('/profile/edit'),
                    onLogout: () => authController.logout(),
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not Logged In", style: TextStyle(fontSize: 22)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    authController.login("mock", "credentials");
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
