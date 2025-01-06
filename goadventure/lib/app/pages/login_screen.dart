import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/main.dart';

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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email input
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Password input
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
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
                    'Login failed: $error',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              onEmpty: Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: const Center(
                  child: Text('No user authenticated'),
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
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
