import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';

/*
 BUG: the problem with LoginScreen showing retry button, is 
 because it's wrapped in ProfileScreen onEmpty if user is not 
 authenticated yet, but on failed login the LoginScreen throws 
 error, which causes parent to show ErrorScreen,
 because both (LoginScreen, ProfileScreen) share authController
 and manage one state.
 TODO: fix above but
 */
class LoginScreen extends GetView<AuthController> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email input
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'email'.tr,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Password input
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'password'.tr,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            // StateMixin's onLoading, onError, onEmpty for handling states
            controller.obx(
              onLoading: const Center(child: CircularProgressIndicator()),
              onError: (error) => Column(
                children: [
                  Text(
                    'login_failed'.tr,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              onEmpty: Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Text('not_logged_in'.tr),
                ),
              ),
              // Default UI when login succeeds (or controller state changes)
              (state) {
                return SizedBox
                    .shrink(); // Return nothing, as we already have the button
              },
            ),
            // Submit button (only displayed once)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Email and password are required.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  // Trigger login using AuthController
                  await controller.login(email, password);
                },
                child: Text('login'.tr),
              ),
            ),
            const SizedBox(height: 16),
            // Link to Register page
            Center(
              child: GestureDetector(
                onTap: () => Get.toNamed('/register'),
                child: Text(
                  '${'no_account_question'.tr} ${'register'.tr}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'login_settings_fab',
        onPressed: () => Get.toNamed('/settings'),
        child: const Icon(Icons.settings),
        tooltip: 'Settings',
      ),
    );
  }
}
