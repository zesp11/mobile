import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/home_controller.dart';

// TODO: split it into multiple files
// TODO: use data from controllers instead of mock ups
class HomeScreen extends StatelessWidget {
  final HomeController controller =
      Get.put(HomeController(homeService: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            UserSummaryWidget(),
            Divider(),
            SearchGamesSection(),
            Divider(),
            LastGameWidget(),
            Divider(),
            NearbyGamesWidget(),
            Divider(),
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
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the search page
          Get.toNamed(
              '/search'); // This assumes you have set up '/search' route in your GetX routing
        },
        child: const Text(
          "Go to Search",
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, // Corrected property name
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// Displays the current user's summary, including achievements and last game completion.
class UserSummaryWidget extends StatelessWidget {
  const UserSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return SectionWidget(
      title: "User Summary",
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        color: Colors.blueGrey,
        child: ListTile(
          leading: const Icon(Icons.person, size: 40, color: Colors.white),
          title: const Text(
            "Guest", // Mocked data
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
                "Achievements: None", // Mocked data
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Text(
                "Last Game Completed: N/A", // Mocked data
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
  const RecommendedGamesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return SectionWidget(
      title: "Recommended Games",
      child: Column(
        children: List.generate(3, (index) {
          // Mocked data for recommended games
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 2,
            child: ListTile(
              leading:
                  const Icon(Icons.thumb_up, color: Colors.green, size: 30),
              title: Text(
                "Mock Recommended Game $index", // Mocked data
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Rating: Mock Rating"), // Mocked data
            ),
          );
        }),
      ),
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
