import 'package:get/get.dart';
import '../services/api_service/api_service.dart';

class HomeController extends GetxController {
  final ApiService apiService; // Declare the ApiService dependency

  // Observables for state management
  var nearbyGames = <Map<String, String>>[].obs;
  var lastGame = Rx<Map<String, String>?>(null);

  // Constructor accepting ApiService
  HomeController({required this.apiService});

  @override
  void onInit() {
    super.onInit();
    // Initialize mock data
    nearbyGames.assignAll([
      {"title": "Dragon's Quest", "distance": "2 km"},
      {"title": "Zombie Escape", "distance": "5 km"},
      {"title": "Mystery Mansion", "distance": "1.5 km"},
      {"title": "Alien Invasion", "distance": "3 km"},
      {"title": "Space Odyssey", "distance": "4.5 km"},
    ]);
    lastGame.value = {
      "title": "Wizard's Journey",
      "progress": "Chapter 4 - The Mystic Forest",
    };
  }

  void resumeLastGame() {
    if (lastGame.value != null) {
      print("Resuming ${lastGame.value!['title']}");
    }
  }

  void startNewGame(Map<String, String> game) {
    print("Starting ${game['title']}");
  }
}
