// Displays the current user's summary, including achievements and last game completion.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/profile_controller.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/ui/widgets/section_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileSummaryWidget extends GetView<ProfileController> {
  final AuthController auth = Get.find<AuthController>();

  ProfileSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.state?.id != null) {
        controller.fetchUserProfile(auth.state!.id.toString());
      }
    });

    return SectionWidget(
      child: controller.obx(
        (profile) => _buildProfileCard(profile, context),
        onLoading: _buildSkeletonLoader(context),
        onError: (error) => Card(
          child: ListTile(
            leading: const Icon(Icons.error_outline, color: Colors.red),
            title: Text('Error loading profile'.tr),
            subtitle: Text(error ?? 'Unknown error'),
          ),
        ),
        onEmpty: Card(
          child: ListTile(
            leading: Icon(Icons.person,
                color: Theme.of(context).colorScheme.secondary),
            title:
                Text('Guest', style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(User? profile, BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Get.rootDelegate.toNamed(AppRoutes.profile),
        borderRadius: BorderRadius.circular(4),
        child: ListTile(
          leading: profile!.photoUrl == null
              ? CircleAvatar(
                radius: 20,
                child: Text(profile.login.isNotEmpty ? profile.login[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
              : CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(profile.photoUrl!),
                ),
          title: Text(
            profile.login,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${"achievements".tr}: ${0}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Obx(() => Text(
                    controller.currentLocation.value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return Card(
      child: Skeletonizer(
        enabled: true,
        child: ListTile(
          leading: const CircleAvatar(radius: 20),
          title: Text(
            'Loading username',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Achievements: Loading...',
                  style: Theme.of(context).textTheme.bodyMedium),
              Text('Last Game Completed: Loading...',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
