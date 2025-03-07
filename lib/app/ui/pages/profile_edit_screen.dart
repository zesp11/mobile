import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/profile_controller.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the current user's profile when entering the screen
    controller.fetchCurrentUserProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Center(
        child: Obx(() {
          final userProfile = controller.userProfile.value;
          if (userProfile == null) {
            return const CircularProgressIndicator();
          }

          // Update text controllers with current values
          nameController.text = userProfile.name;
          emailController.text = userProfile.email;
          bioController.text = userProfile.bio;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password (leave blank to keep current)',
                    helperText:
                        'Only fill this if you want to change your password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await controller.updateProfile(
                        nameController.text,
                        bioController.text,
                        emailController.text,
                        passwordController.text.isEmpty
                            ? null
                            : passwordController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile updated!")),
                      );
                      Get.back();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error updating profile: $e")),
                      );
                    }
                  },
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
