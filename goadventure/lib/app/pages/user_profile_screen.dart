import 'package:flutter/material.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/pages/error_screen.dart';
import 'package:goadventure/app/pages/widgets/user_profile.dart';

// TODO: redirect to /profile if its user own profile, but using middleware
class UserProfileScreen extends GetView<ProfileController> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final String userId = Get.parameters['id']!;

    // Redirect to '/profile' if the user views their own profile
    if (authController.state?.id == userId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed('/profile');
      });
    }

    // Fetch the user profile if it's not already loaded
    if (controller.state?.id != userId) {
      controller.fetchUserProfile(userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: controller.obx(
        // Success state
        (userProfile) {
          if (userProfile == null) {
            return const Center(child: Text('User profile not found.'));
          }
          return Center(
            child: UserProfileWidget(userProfile: userProfile),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text('User profile not found.')),
        onError: (error) => Center(
          child: ErrorScreen(
            error: error ?? 'An error occurred',
            onRetry: () => controller.fetchUserProfile(userId),
          ),
        ),
      ),
    );
  }
}
