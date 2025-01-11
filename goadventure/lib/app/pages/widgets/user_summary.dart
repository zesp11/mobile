// Displays the current user's summary, including achievements and last game completion.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:goadventure/app/pages/widgets/section_widget.dart';

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          color: Colors.blueGrey,
          child: ListTile(
            leading: userProfile != null && userProfile.avatar.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(userProfile.avatar),
                    radius: 20,
                  )
                : const Icon(Icons.person, size: 40, color: Colors.white),
            title: Text(
              userProfile?.name ?? "Guest",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Achievements: ${userProfile?.preferences['achievements'] ?? 'None'}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Last Game Completed: ${userProfile?.preferences['lastGame'] ?? 'N/A'}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
