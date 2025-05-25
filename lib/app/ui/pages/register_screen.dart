import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/utils/snackbar.dart';

class RegisterScreen extends GetView<AuthController> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'register'.tr,
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'create_account'.tr,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'register_subtitle'.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),

                // Name input
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'name'.tr,
                    hintText: 'enter_name'.tr,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: theme.colorScheme.tertiary,
                    ),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.tertiary,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: theme.colorScheme.secondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiary.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiary.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  style: theme.textTheme.bodyLarge,
                  cursorColor: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 20),

                // Email input
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                    hintText: 'enter_email'.tr,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: theme.colorScheme.tertiary,
                    ),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.tertiary,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: theme.colorScheme.secondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiary.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiary.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: theme.textTheme.bodyLarge,
                  cursorColor: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 20),

                // Password input
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'password'.tr,
                    hintText: 'enter_password'.tr,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: theme.colorScheme.tertiary,
                    ),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.tertiary,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: theme.colorScheme.secondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiary.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiary.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  obscureText: true,
                  style: theme.textTheme.bodyLarge,
                  cursorColor: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 20),

                // Confirm Password input
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'confirm_password'.tr,
                    hintText: 'reenter_password'.tr,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: theme.colorScheme.tertiary,
                    ),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.tertiary,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: theme.colorScheme.secondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiary.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiary.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  obscureText: true,
                  style: theme.textTheme.bodyLarge,
                  cursorColor: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 24),

                Obx(() {
                  if (controller.registerStatus.value.isLoading) {
                    return Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'creating_account'.tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  if (controller.registerStatus.value.isError) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              controller.registerStatus.value.errorMessage ??
                                  'registration_failed'.tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      final confirmPassword =
                          confirmPasswordController.text.trim();

                      if (name.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
                        showAppSnackbar(
                            title: "error".tr,
                            message: "all_fields_are_required".tr,
                            type: SnackbarType.info);
                        return;
                      }

                      if (password != confirmPassword) {
                        showAppSnackbar(
                            title: "error".tr,
                            message: "password_do_not_match".tr,
                            type: SnackbarType.error);
                        return;
                      }

                      await controller.register(name, email, password);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text('register'.tr),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Link
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed('/login'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      '${"already_registered".tr} ${"login".tr}!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
