import 'package:flutter/material.dart';
import 'package:gotale/app/models/user.dart';

class UserProfileWidget extends StatelessWidget {
  final User userProfile;

  const UserProfileWidget({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: userProfile.photoUrl != null
              ? NetworkImage(userProfile.photoUrl!)
              : null,
          child: userProfile.photoUrl == null
              ? const Icon(Icons.person, size: 60, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 20),
        Text(userProfile.login,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(userProfile.email,
            style: const TextStyle(fontSize: 18, color: Colors.grey)),
        const SizedBox(height: 10),
        Text("TODO: not present in user model",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Text("Games Played: ${-1}",
            style: const TextStyle(fontSize: 18, color: Colors.grey)),
        const SizedBox(height: 5),
        Text(
          "Games Finished: ${-1}",
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    ); //
  }
}
