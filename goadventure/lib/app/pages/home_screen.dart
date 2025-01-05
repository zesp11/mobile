import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/controllers/home_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:goadventure/app/routes/app_routes.dart';

// TODO: split it into multiple files
// TODO: use data from controllers instead of mock ups
class HomeScreen extends StatelessWidget {
  final HomeController controller =
      Get.put(HomeController(homeService: Get.find()));
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (authController.isAuthenticated) ...[
              UserSummaryWidget(),
              const Divider(),
            ],
            const SearchGamesSection(),
            // const Divider(),
            // const LastGameWidget(),
            // TODO:
            // const Divider(),
            // const NearbyGamesWidget(),
            const Divider(),
            RecommendedGamesWidget(),
          ],
        ),
      ),
    );
  }
}

// New Section with Button for Navigating to Search Games Page
class SearchGamesSection extends StatelessWidget {
  const SearchGamesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      title: "Search Games",
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.gamepad_outlined,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 10),
            const Text(
              "Discover New Adventures!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Explore a vast collection of games and scenarios. Dive into unique storylines and find your next favorite game.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Use GetRouterOutletDelegate to update the content in the current layout
                Get.rootDelegate.toNamed(AppRoutes.search);
              },
              icon: const Icon(Icons.search, size: 24),
              label: const Text(
                "Find Games",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Displays the current user's summary, including achievements and last game completion.
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

// Displays details of the last game played by the user.
class LastGameWidget extends StatelessWidget {
  const LastGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return SectionWidget(
      title: "Last Game",
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        color: Colors.blueAccent,
        child: ListTile(
          leading: const Icon(Icons.play_arrow, size: 40, color: Colors.white),
          title: const Text(
            "Mock Game Title", // Mocked data
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Started: Mock Date", // Mocked data
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Text(
                "Steps: 0", // Mocked data
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Lists games near the user's location.
class NearbyGamesWidget extends StatelessWidget {
  const NearbyGamesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return SectionWidget(
      title: "Nearby Games",
      child: Column(
        children: List.generate(3, (index) {
          // Mocked data for nearby games
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.location_on,
                  color: Colors.redAccent, size: 30),
              title: Text(
                "Mock Game Title $index", // Mocked data
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Started: Mock Date"), // Mocked data
            ),
          );
        }),
      ),
    );
  }
}

// Suggests games based on user preferences.
class RecommendedGamesWidget extends StatelessWidget {
  final GameController controller = Get.find();

  RecommendedGamesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      title: "Recommended Games",
      child: Obx(() {
        if (controller.isAvailableGamebooksLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.availableGamebooks.isEmpty) {
          return const Center(
            child: Text(
              "No recommended games available.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: controller.availableGamebooks.map((gamebook) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              elevation: 3,
              child: SizedBox(
                height: 100, // Fixed height for all cards
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.gamepad, // Improved icon
                        color: Colors.blueAccent,
                        size: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gamebook.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              // "Rating: ${gamebook.rating.toStringAsFixed(1)}",
                              "Rating: ${9.1}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_forward, color: Colors.grey),
                        onPressed: () {
                          Get.toNamed('/scenario/${gamebook.id}');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}

// A reusable section widget for displaying content with a title.
class SectionWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionWidget({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
