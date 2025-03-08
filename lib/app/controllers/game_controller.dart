import 'package:get/get.dart';
import 'package:gotale/app/models/decision.dart';
import 'package:gotale/app/models/gamebook.dart';
import 'package:gotale/app/models/step.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:logger/logger.dart';

// This screen focuses on the active game session.
// It manages the game logic, decisions, and interactions with other players.
// TODO: split this into GameRunning and GamesController
class GameSelectionController extends GetxController {
  final GameService gameService;
  final logger = Get.find<Logger>();

  // List of available gamebooks
  var availableGamebooks = <Gamebook>[].obs;
  var isAvailableGamebooksLoading = false.obs;

  // List of games in progress
  var gamesInProgress = <Map<String, dynamic>>[].obs;
  var isGamesInProgressLoading = false.obs;

  GameSelectionController({required this.gameService});

  @override
  void onInit() {
    super.onInit();
    fetchAvailableGamebooks();
    fetchGamesInProgress();
  }

  // Fetch the list of available gamebooks
  Future<void> fetchAvailableGamebooks() async {
    isAvailableGamebooksLoading.value = true;
    try {
      logger.i("[DEV_DEBUG] Fetching available gamebooks");
      final gamebooks = await gameService.fetchAvailableGamebooks();
      availableGamebooks.assignAll(gamebooks);
    } catch (e) {
      logger.e("Error fetching available gamebooks: $e");
    } finally {
      isAvailableGamebooksLoading.value = false;
    }
  }

  // Fetch games in progress
  Future<void> fetchGamesInProgress() async {
    isGamesInProgressLoading.value = true;
    try {
      logger.i("[DEV_DEBUG] Fetching games in progress");
      final games = await gameService.fetchGamesInProgress();
      logger.i("[DEV_DEBUG] Found ${games.length} games in progress");
      logger.d("[DEV_DEBUG] Games data: $games");
      gamesInProgress.assignAll(games);
    } catch (e) {
      logger.e("Error fetching games in progress: $e");
    } finally {
      isGamesInProgressLoading.value = false;
    }
  }

  // Resume a game
  Future<void> resumeGame(int gameId) async {
    try {
      logger.i("[DEV_DEBUG] Resuming game with ID: $gameId");
      await gameService.fetchGamebookData(gameId);
    } catch (e) {
      logger.e("Error resuming game: $e");
      rethrow;
    }
  }
}

class GamePlayController extends GetxController with StateMixin {
  final GameService gameService;
  final logger = Get.find<Logger>();

  // Reactive variable for the selected gamebook
  Rx<Gamebook?> currentGamebook = Rx<Gamebook?>(null);

  final showPostDecisionMessage = false.obs;
  final hasArrivedAtLocation = false.obs;
  void confirmArrival() {
    showPostDecisionMessage.value = false;
    hasArrivedAtLocation.value = true;
  }

  // Reactive variable for the current step of the gamebook
  Rx<Step?> currentStep = Rx<Step?>(null);

  // History to store the sequence of decisions and steps
  var gameHistory = RxList<String>([]);

  var isCurrentGamebookLoading = false.obs;

  GamePlayController({required this.gameService});

  // Create a new game from a scenario
  Future<Map<String, dynamic>> createGameFromScenario(int scenarioId) async {
    change(null, status: RxStatus.loading());
    try {
      final gameData = await gameService.createGameFromScenario(scenarioId);

      // Create a new Gamebook from the response
      final gamebook = Gamebook(
        id: gameData['id_game'] ?? 0,
        title: gameData['name'] ?? 'Untitled Game',
        description: 'Game created from scenario',
        startDate: DateTime.now(),
        endDate: null,
        steps: [], // We'll populate this with the first step
        authorId: gameData['id_author'] ?? 0,
      );

      logger.d("Created game with id: ${gamebook.id}");

      // Set the current gamebook
      currentGamebook.value = gamebook;

      // Fetch the first step
      await fetchCurrentStep(gamebook.id);

      change(null, status: RxStatus.success());
      return gameData;
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
      final stepData = await gameService.getCurrentStep(gameId);
      logger.d("[DEV_DEBUG] Step data response: $stepData");

      final step = stepData['step'];
      logger.d("[DEV_DEBUG] Parsed step object: $step");

      if (step != null) {
        final currentStep = Step(
          id: step['id_step'] ?? 1,
          title: step['title'] ?? 'Current Step',
          text: step['text'] ?? '',
          latitude: step['latitude']?.toDouble() ?? 0.0,
          longitude: step['longitude']?.toDouble() ?? 0.0,
          decisions: (step['choices'] as List?)
                  ?.map((choice) => Decision(
                        text: choice['text'] ?? '',
                        nextStepId: choice['id_next_step'] ?? 0,
                      ))
                  .toList() ??
              [],
        );

        logger.i("[DEV_DEBUG] Created Step object: $currentStep");
        logger.d(
            "[DEV_DEBUG] Number of choices: ${currentStep.decisions.length}");
        this.currentStep.value = currentStep;
      } else {
        logger.w("[DEV_DEBUG] No step data found in response");
      }
    } catch (e) {
      logger.e("[DEV_DEBUG] Error fetching current step: $e");
      throw Exception("Failed to fetch current step: $e");
    }
  }

  // Fetch the current gamebook data and initialize the first step
  Future<void> fetchGamebookData(int id) async {
    change(null, status: RxStatus.loading());
    gameHistory.clear();
    try {
      logger.i("[DEV_DEBUG] Fetching game data for ID: $id");
      final gameData = await gameService.getGamePlay(id);
      logger.d("[DEV_DEBUG] Game data response: $gameData");

      // Create Gamebook from the response
      final gamebook = Gamebook(
        id: gameData['id_game'] ?? 0,
        title: gameData['name'] ?? 'Untitled Game',
        description: 'Game in progress',
        startDate: DateTime.now(),
        endDate: null,
        steps: [], // We'll populate this with the current step
        authorId: gameData['id_author'] ?? 0,
      );

      logger.i("[DEV_DEBUG] Created Gamebook object: $gamebook");
      currentGamebook.value = gamebook;
      hasArrivedAtLocation.value = false;
      showPostDecisionMessage.value = false;

      // Fetch the current step separately
      await fetchCurrentStep(id);

      change(null, status: RxStatus.success());
    } catch (e) {
      logger.e("[DEV_DEBUG] Error fetching gamebook: $e");
      change(null, status: RxStatus.error("Error fetching gamebook"));
    }
  }

  void updateCurrentGamebook(int id) {
    fetchGamebookData(id);
  }

  void makeDecision(Decision decision) async {
    showPostDecisionMessage.value = true;
    hasArrivedAtLocation.value = false;
    if (currentStep.value != null) {
      gameHistory.add("Step: ${currentStep.value!.text}");
    }

    gameHistory.add("Decision: ${decision.text}");

    // Fetch the next step
    if (currentGamebook.value != null) {
      await fetchCurrentStep(currentGamebook.value!.id);
    }
  }

  bool isGamebookSelected() {
    return currentGamebook.value != null;
  }

  String getGameHistory() {
    if (gameHistory.isEmpty) {
      return "There is no history yet, travel around the world to create your own...";
    } else {
      return gameHistory.join('\n');
    }
  }
}
