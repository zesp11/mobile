import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';

class RegisterScreen extends GetView<AuthController> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name input
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            // Confirm Password input
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            // StateMixin handling states
            controller.obx(
              onLoading: const Center(child: CircularProgressIndicator()),
              onError: (error) => Column(
                children: [
                  Text(
                    'Registration failed: $error',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              onEmpty: SizedBox.shrink(),
              (state) {
                return SizedBox.shrink();
              },
            ),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (name.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      confirmPassword.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'All fields are required.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    Get.snackbar(
                      'Error',
                      'Passwords do not match.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  await controller.register(name, email, password);
                },
                child: const Text('Register'),
              ),
            ),
            const SizedBox(height: 16),
            // Link to Login Screen if user already has an account
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to login screen
                  Get.toNamed('/login');
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
