import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/pages/error_screen.dart';
import 'package:goadventure/app/pages/widgets/user_profile.dart';

// TODO: redirect to /profile if its user own profile, but using middleware
class UserProfileScreen extends GetView<ProfileController> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final String userId = Get.parameters['id']!;

    if (authController.userProfile.value?.id == userId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed('/profile');
      });
    }

    if (controller.userProfile.value?.id != userId) {
      controller.fetchUserProfile(userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: Center(
        child: controller.obx(
          onLoading: const CircularProgressIndicator(),
          onError: (error) => ErrorScreen(
            error: error,
            onRetry: () => controller.fetchUserProfile(userId),
          ),
          onEmpty: const Text('User profile not found.'),
          (userProfile) {
            if (userProfile == null) {
              return const Text('User profile not found.');
            }
            return UserProfileWidget(userProfile: userProfile);
          },
        ),
      ),
    );
  }
}
