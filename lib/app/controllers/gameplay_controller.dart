import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gotale/app/models/choice.dart';
import 'package:gotale/app/models/game.dart';
import 'package:gotale/app/models/game_history_record.dart';
import 'package:gotale/app/models/game_step.dart';
import 'package:gotale/app/models/lobby.dart' as lobbyModel;
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/models/user_location.dart';
import 'package:gotale/app/services/lobby_service.dart';
import 'package:gotale/app/services/user_service.dart';
import 'package:gotale/app/ui/pages/game_play_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';

enum GameType { single, multi }

class GamePlayController extends GetxController with StateMixin {
  final Rx<String?> jwtToken = Rx<String?>(null);
  final Map<String, User> _cachedUsers = {};

  final FlutterSecureStorage secureStorage = Get.find<FlutterSecureStorage>();

  Future<String?> getCurrentUserId() async {
    return await secureStorage.read(key: 'userId');
  }

  @override
  void onInit() {
    super.onInit();
    loadToken();
  }

  RxList<UserLocation> userLocations = <UserLocation>[].obs;
  //List<UserLocation> userLocations = [];
  final UserService userService = Get.find<UserService>();

  Future<void> displayUserMarkers(Map<String, LatLng> idToCoordinates) async {
    List<UserLocation> loaded = [];

    for (final entry in idToCoordinates.entries) {
      try {
        final userId = entry.key;

        User user;
        if (_cachedUsers.containsKey(userId)) {
          user = _cachedUsers[userId]!;
        } else {
          user = await userService.fetchUserProfile(userId);
          _cachedUsers[userId] = user;
        }
        loaded.add(
          UserLocation(
            userId: entry.key,
            position: entry.value,
            photoUrl: user.photoUrl,
            login: user.login,
          ),
        );
      } catch (e) {
        print("Failed to load user ${entry.key}: $e");
      }
    }

    userLocations.value = loaded;
  }

  Future<void> loadToken() async {
    final token = await secureStorage.read(key: 'accessToken');
    if (token != null) {
      jwtToken.value = 'Bearer $token';
      //print(jwtToken.value); //delete this later ofc
    } else {
      jwtToken.value = null;
    }
  }

  /*void setToken(String token) {
    jwtToken.value = "Bearer token";
  }*/

  final GameService gameService;
  final logger = Get.find<Logger>();
  final _devBypassLocation = false.obs;

  GameType gameType = GameType.single;

  void toggleDevBypassLocation(bool value) {
    _devBypassLocation.value = value;
  }

  bool get isDevMode => _devBypassLocation.value;

  // Development mode flag - set to true for development, false for production
  static const bool isDevelopmentMode = true;

  // Reactive variable for the selected gamebook
  Rx<Game?> currentGame = Rx<Game?>(null);

  final showPostDecisionMessage = false.obs;
  final hasArrivedAtLocation = false.obs;
  void confirmArrival() {
    showPostDecisionMessage.value = false;
    hasArrivedAtLocation.value = true;
  }

  // Reactive variable for the current step of the gamebook
  Rx<GameStep?> currentStep = Rx<GameStep?>(null);

  // History to store the sequence of decisions and steps
  var gameHistory = RxList<GameHistoryRecord>([]);
  var isHistoryLoading = false.obs;

  var isCurrentGamebookLoading = false.obs;

  // Add new observable for game state
  final isGameEnded = false.obs;

  GamePlayController({required this.gameService});

  // Fetch game history
  Future<void> fetchGameHistory(int gameId) async {
    try {
      isHistoryLoading.value = true;
      logger.i("[DEV_DEBUG] Fetching game history for ID: $gameId");
      final history = await gameService.getGameHistory(gameId);
      logger.d("[DEV_DEBUG] Game history response: $history");

      // Sort history by start_date in ascending order (oldest first)
      // history.sort((a, b) =>
      //     (a['start_date'] as String).compareTo(b['start_date'] as String));
      gameHistory.assignAll(history);

      logger.i("[DEV_DEBUG] Loaded ${gameHistory.length} history entries");
    } catch (e) {
      logger.e("[DEV_DEBUG] Error fetching game history: $e");
    } finally {
      isHistoryLoading.value = false;
    }
  }

  // Create a new game from a scenario
  Future<void> createGameFromScenario(int scenarioId) async {
    change(null, status: RxStatus.loading());
    try {
      final createdGame = await gameService.createGameFromScenario(scenarioId);

      logger.d("Created game $createdGame");

      // cast to correct game object, because incorrect backend response
      currentGame.value = Game(
        startTime: DateTime.now(),
        currentStepText: createdGame.firstStep.text ?? "Game End",
        scenarioName: createdGame.name,
        idGame: createdGame.idGame,
        idScen: scenarioId,
        currentStep: createdGame.firstStep.id,
      );

      // Fetch the first step
      await fetchCurrentStep(currentGame.value!.idGame);

      change(null, status: RxStatus.success());
    } catch (e) {
      logger.e("Error creating game from scenario: $e");
      change(null,
          status: RxStatus.error("Failed to create game from scenario"));
      throw e;
    }
  }

  // Fetch the current step of the game
  Future<void> fetchCurrentStep(int gameId) async {
    try {
      logger.i("[DEV_DEBUG] Fetching current step for game ID: $gameId");
      final step = await gameService.getCurrentStep(gameId);
      // Check for end of game
      if (step.title == 'EOG' && step.title == 'END_OF_GAME') {
        logger.i("[DEV_DEBUG] Game has ended");
        isGameEnded.value = true;
        currentStep.value = GameStep(
          id: 0,
          title: 'Game Over',
          text: 'Congratulations! You have completed the game.',
          latitude: 0.0,
          longitude: 0.0,
          choices: [],
        );
        return;
      }
      logger.i("[DEV_DEBUG] Created Step object: $step");
      logger.d("[DEV_DEBUG] Number of choices: ${step.choices.length}");
      currentStep.value = step;

      // If the coords are not 0, then add new waypoint
      if (step.latitude != 0.0 &&
          step.longitude != 0.0 &&
          step.latitude != null &&
          step.longitude != null) {
        addWaypoint(step.latitude!, step.longitude!);
        //addWaypoint(52.06516, 19.25248);
        logger.i(
            "[DEV_DEBUG] Added waypoint: (${step.latitude}, ${step.longitude})");
      }

      isGameEnded.value = false;
    } catch (e) {
      logger.e("[DEV_DEBUG] Error fetching current step: $e");
      throw Exception("Failed to fetch current step: $e");
    }
  }

  // Fetch the current gamebook data and initialize the first step
  Future<void> fetchGameWithId(int id) async {
    change(null, status: RxStatus.loading());
    gameHistory.clear();
    isGameEnded.value = false;
    try {
      logger.i("[DEV_DEBUG] Fetching game data for game id=$id");
      final game = await gameService.getGameWithId(id);
      logger.d("[DEV_DEBUG] Game data response: $game");

      currentGame.value = game;
      hasArrivedAtLocation.value = false;
      showPostDecisionMessage.value = false;

      //   // Fetch the current step and history
      await Future.wait([
        fetchCurrentStep(id),
        fetchGameHistory(id),
      ]);

      gameType = GameType.single;

      change(null, status: RxStatus.success());
    } catch (e) {
      logger.e("[DEV_DEBUG] Error fetching gamebook: $e");
      change(null, status: RxStatus.error("Error fetching gamebook"));
    }
  }

  void updateCurrentGamebook(int id) {
    fetchGameWithId(id);
  }

  void makeDecision(Choice decision) async {
    logger.d('user makes following decision ${decision.idChoice}');
    if (!isDevelopmentMode) {
      // In production mode, require location verification
      showPostDecisionMessage.value = true;
      hasArrivedAtLocation.value = false;
    }

    await _processDecision(decision);
  }

  Future<void> _processDecision(Choice decision) async {
    if (currentStep.value != null && currentGame.value != null) {
      try {
        // Make the decision through the API
        final response = await gameService.makeDecision(
            currentGame.value!.idGame, decision.idChoice);

        logger.d("[DEV_DEBUG] Decision response: $response");

        // Fetch updated history after making the decision
        Future.wait([
          fetchGameHistory(currentGame.value!.idGame),
          fetchCurrentStep(currentGame.value!.idGame),
        ]);

        if (!isDevelopmentMode) {
          /*if (currentStep.value != null &&
            currentStep.value!.latitude != null &&
            currentStep.value!.longitude != null &&
            (currentStep.value!.latitude != 0.0 ||
                currentStep.value!.longitude != 0.0)) {
          // When new step requires localisation
          showPostDecisionMessage.value = false;
          hasArrivedAtLocation.value = false;
        } else {
          showPostDecisionMessage.value = false;
          hasArrivedAtLocation.value = true;
        }*/
          hasArrivedAtLocation.value = false;
        }
      } catch (e) {
        logger.e("[DEV_DEBUG] Error processing decision: $e");
        throw Exception("Failed to process decision: $e");
      }
    }
  }

  bool isGamebookSelected() {
    return currentGame.value != null;
  }

  String getGameHistory() {
    if (gameHistory.isEmpty) {
      return "There is no history yet, travel around the world to create your own...";
    } else {
      return gameHistory.join('\n');
    }
  }

  // THIS IS IMPORTANT (DO NOT DELETE) - required in future
  Future<void> checkLocation() async {
    try {
      if (waypoints.isEmpty) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final currentLatLng = LatLng(position.latitude, position.longitude);
      final distance =
          const Distance().as(LengthUnit.Meter, currentLatLng, waypoints.last);

      if (distance <= MapWidget.arrivalRadiusMeters) {
        hasArrivedAtLocation.value = true;
        showPostDecisionMessage.value = false;
      }
    } catch (e) {
      logger.e("[DEV_DEBUG] Error checking location: $e");
    }
  }

  void onReturnToSelection() {
    isGameEnded.value = false;
    currentStep.value = null;
    Get.offNamed('/game-selection');
  }

  var waypoints = <LatLng>[].obs;

  void addWaypoint(double latitude, double longitude) {
    waypoints.clear();
    waypoints.add(LatLng(latitude, longitude));
  }

  final LobbyService lobbyService = Get.find();
  final Rxn<lobbyModel.Lobby> createdLobby = Rxn<lobbyModel.Lobby>();

  Future<lobbyModel.Lobby> createLobby(int id) async {
    //do usunięcia potem
    try {
      final lobby = await lobbyService.createLobby(id, "test");
      //print("Lobby utworzone: ${lobby.name}");
      logger.d("[DEV_DEBUG] Decision response: $lobby");
      createdLobby.value = lobby;
      return lobby;
    } catch (e) {
      logger.e("[DEV_DEBUG] Error processing decision: $e");
      throw Exception("Failed to process decision: $e");
    }
  }
/*
  RxList<UserLocation> userLocations = <UserLocation>[].obs;
  final UserService userService = Get.find<UserService>();

  Future<void> displayUserMarkers(Map<String, LatLng> idToCoordinates) async {
    List<UserLocation> loaded = [];

    for (final entry in idToCoordinates.entries) {
      try {
        final user = await userService.fetchUserProfile(entry.key);
        loaded.add(
          UserLocation(
            userId: entry.key,
            position: entry.value,
            photoUrl: user.photoUrl,
          ),
        );
      } catch (e) {
        print("Failed to load user ${entry.key}: $e");
      }
    }

    userLocations.value = loaded;
  }*/

  @override
  void onClose() {
    // ... existing code ...
  }
}
