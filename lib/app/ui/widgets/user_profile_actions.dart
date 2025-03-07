import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  const UserActionsWidget({
    Key? key,
    required this.onEditProfile,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onEditProfile,
          child: Text("edit_profile".tr),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onLogout,
          child: Text("logout".tr),
        ),
      ],
    );
  }
}
