import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/profile_controller.dart';
import 'package:gotale/app/routes/app_routes.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the current user's profile when entering the screen
    controller.fetchCurrentUserProfile();
  }

  @override
  void dispose() {
    loginController.dispose();
    emailController.dispose();
    bioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'edit_profile'.tr,
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Obx(() {
            final userProfile = controller.userProfile.value;
            if (userProfile == null) {
              return CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              );
            }

            loginController.text = userProfile.login;
            emailController.text = userProfile.email;
            bioController.text = userProfile.bio ?? "";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Input
                  TextField(
                    controller: loginController,
                    readOnly: true,
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

                  // Email Input
                  TextField(
                    controller: emailController,
                    readOnly: true,
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

                  // Bio Input
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      labelText: 'bio'.tr,
                      hintText: 'enter_bio'.tr,
                      prefixIcon: Icon(
                        Icons.description_outlined,
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
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    style: theme.textTheme.bodyLarge,
                    cursorColor: theme.colorScheme.secondary,
                  ),

                  const SizedBox(height: 10),
                  Divider(),
                  const SizedBox(height: 10),

                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'new_password'.tr,
                      hintText: 'enter_new_password'.tr,
                      helperText: 'password_change_hint'.tr,
                      helperStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                      helperMaxLines: 2,
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
                  const SizedBox(height: 4),

                  // Password Confirm Input
                  TextField(
                    controller: passwordConfirmController,
                    decoration: InputDecoration(
                      labelText: 'confirm_new_password'.tr,
                      hintText: 'enter_new_password_confirm'.tr,
                      helperText: 'password_change_confirm_hint'.tr,
                      helperStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                      helperMaxLines: 2,
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
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await controller.updateProfile(
                            loginController.text,
                            bioController.text,
                            emailController.text,
                            passwordController.text.isEmpty
                                ? null
                                : passwordController.text,
                          );
                          Get.snackbar(
                            'success'.tr,
                            'profile_updated'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green.withOpacity(0.1),
                            colorText: Colors.green,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                        } catch (e) {
                          Get.snackbar(
                            'error'.tr,
                            'profile_update_failed'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor:
                                theme.colorScheme.error.withOpacity(0.1),
                            colorText: theme.colorScheme.error,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('save_changes'.tr),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
