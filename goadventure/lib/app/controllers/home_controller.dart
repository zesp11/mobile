import 'package:get/get.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/services/home_service.dart';

class HomeController extends GetxController {
  final HomeService homeService;

  // Observables for state management
  var nearbyGames = <Gamebook>[].obs;
  var lastGame = Rx<Gamebook?>(null);

  // Constructor accepting HomeService
  HomeController({required this.homeService});

  @override
  void onInit() {
    super.onInit();
    // Fetch the nearby games
    fetchNearbyGames();
    // Fetch the last game
    fetchLastGame();
  }

  // Method to fetch nearby games
  void fetchNearbyGames() async {
    nearbyGames.value = await homeService.fetchNearbyGames();
  }

  // Method to fetch last game
  void fetchLastGame() async {
    lastGame.value = await homeService.fetchLastGame();
  }

  void resumeLastGame() {
    if (lastGame.value != null) {
      print("Resuming ${lastGame.value!.title}");
    }
  }

  void startNewGame(Gamebook gamebook) {
    print("Starting ${gamebook.title}");
  }
}
