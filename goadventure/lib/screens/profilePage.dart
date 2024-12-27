import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // TODO: create Profile class that will be JSON serializable
  // mock data
  late String userName;
  late int gamesPlayed;
  late int gamesFinished;

  @override
  void initState() {
    super.initState();

    // initialize mock data
    userName = "John Doe";
    gamesPlayed = 15;
    gamesFinished = 10;

    // TODO: in the future, replace this with an API call
    // TODO: how to handle user own profile and different users profile?
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Stats displayed with dynamic data
            Text(
              "Games Played: $gamesPlayed",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Games Finished: $gamesFinished",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Edit Profile clicked!"),
                  ),
                );
              },
              child: const Text("Edit Profile"),
            )
          ],
        ),
      ),
    );
  }
}
