import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/ui/pages/login_screen.dart';
import 'package:goadventure/app/ui/widgets/user_profile.dart';
import 'package:goadventure/app/ui/widgets/user_profile_actions.dart';

class ProfileScreen extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: controller.obx(
        // Success state
        (userProfile) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserProfileWidget(userProfile: userProfile!),
              const SizedBox(height: 20),
              UserActionsWidget(
                onEditProfile: () => Get.toNamed('/profile/edit'),
                onLogout: () => controller.logout(),
              ),
            ],
          ),
        ),
        // Loading state
        onLoading: const Center(child: CircularProgressIndicator()),
        // Empty state (e.g., not logged in)
        onEmpty: LoginScreen(),
        // Error state
        onError: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error ?? "Something went wrong",
                  style: const TextStyle(fontSize: 18, color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.checkAuthStatus();
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
