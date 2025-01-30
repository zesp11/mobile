// Displays the current user's summary, including achievements and last game completion.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:goadventure/app/ui/widgets/section_widget.dart';

class UserSummaryWidget extends StatelessWidget {
  final ProfileController profile = Get.find<ProfileController>();

  UserSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      title: "User Summary",
      child: Obx(() {
        final userProfile = profile.userProfile.value;
        return Card(
          child: ListTile(
            leading: userProfile != null && userProfile.avatar.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(userProfile.avatar),
                    radius: 20,
                  )
                : Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            title: Text(
              userProfile?.name ?? "Guest",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Achievements: ${userProfile?.preferences['achievements'] ?? 'None'}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  "Last Game Completed: ${userProfile?.preferences['lastGame'] ?? 'N/A'}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
