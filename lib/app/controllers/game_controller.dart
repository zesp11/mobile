import 'package:get/get.dart';
import 'package:gotale/app/models/choice.dart';
import 'package:gotale/app/models/scenario.dart';
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
  var availableGamebooks = <Scenario>[].obs;
  var isAvailableGamebooksLoading = false.obs;

  // List of games in progress
  var gamesInProgress = <Map<String, dynamic>>[].obs;
  var isGamesInProgressLoading = false.obs;

  GameSelectionController({required this.gameService});

  @override
  void onInit() {
    super.onInit();
    fetchAvailableGamebooks();
    // fetchGamesInProgress();
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

  // Development mode flag - set to true for development, false for production
  static const bool isDevelopmentMode = true;

  // Reactive variable for the selected gamebook
  Rx<Scenario?> currentGamebook = Rx<Scenario?>(null);

  final showPostDecisionMessage = false.obs;
  final hasArrivedAtLocation = false.obs;
  void confirmArrival() {
    showPostDecisionMessage.value = false;
    hasArrivedAtLocation.value = true;
  }

  // Reactive variable for the current step of the gamebook
  Rx<Step?> currentStep = Rx<Step?>(null);

  // History to store the sequence of decisions and steps
  var gameHistory = RxList<Map<String, dynamic>>([]);
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
      history.sort((a, b) =>
          (a['start_date'] as String).compareTo(b['start_date'] as String));
      gameHistory.assignAll(history);

      logger.i("[DEV_DEBUG] Loaded ${gameHistory.length} history entries");
    } catch (e) {
      logger.e("[DEV_DEBUG] Error fetching game history: $e");
    } finally {
      isHistoryLoading.value = false;
    }
  }

  // Create a new game from a scenario
  Future<Map<String, dynamic>> createGameFromScenario(int scenarioId) async {
    change(null, status: RxStatus.loading());
    try {
      // final gameData = await gameService.createGameFromScenario(scenarioId);

      // TODO:
      throw UnimplementedError("createGameFromScenario is not implemented yet");
      // // Create a new Gamebook from the response
      // final gamebook = Scenario(
      //   id: gameData['id_game'] ?? 0,
      //   title: gameData['name'] ?? 'Untitled Game',
      //   description: 'Game created from scenario',
      //   startDate: DateTime.now(),
      //   endDate: null,
      //   steps: [], // We'll populate this with the first step
      //   authorId: gameData['id_author'] ?? 0,
      // );

      // logger.d("Created game with id: ${gamebook.id}");

      // // Set the current gamebook
      // currentGamebook.value = gamebook;

      // // Fetch the first step
      // await fetchCurrentStep(gamebook.id);

      // change(null, status: RxStatus.success());
      // return gameData;
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
        // Check for end of game
        if (step['title'] == 'EOG' && step['text'] == 'END_OF_GAME') {
          logger.i("[DEV_DEBUG] Game has ended");
          isGameEnded.value = true;
          currentStep.value = Step(
            id: 0,
            title: 'Game Over',
            text: 'Congratulations! You have completed the game.',
            latitude: 0.0,
            longitude: 0.0,
            choices: [],
          );
          return;
        }

        final newStep = stepFromJson(step);

        logger.i("[DEV_DEBUG] Created Step object: $newStep");
        logger.d("[DEV_DEBUG] Number of choices: ${newStep.choices.length}");
        currentStep.value = newStep;
        isGameEnded.value = false;
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
    throw UnimplementedError("fetchGamebookData");
    // change(null, status: RxStatus.loading());
    // gameHistory.clear();
    // isGameEnded.value = false;
    // try {
    //   logger.i("[DEV_DEBUG] Fetching game data for ID: $id");
    //   final gameData = await gameService.getGamePlay(id);
    //   logger.d("[DEV_DEBUG] Game data response: $gameData");

    //   // Create Gamebook from the response
    //   final gamebook = scenarioFromJson(
    //     id: id,
    //     cwiid: id,
    //     title: gameData['name'] ?? 'Untitled Game',
    //     description: 'Game in progress',
    //     startDate: DateTime.now(),
    //     endDate: null,
    //     steps: [], // We'll populate this with the current step
    //     authorId: gameData['id_author'] ?? 0,
    //   );

    //   logger.i("[DEV_DEBUG] Created Gamebook object: $gamebook");
    //   logger.d("[DEV_DEBUG] Game ID: ${gamebook.id}");
    //   currentGamebook.value = gamebook;
    //   hasArrivedAtLocation.value = false;
    //   showPostDecisionMessage.value = false;

    //   // Fetch the current step and history
    //   await Future.wait([
    //     fetchCurrentStep(id),
    //     fetchGameHistory(id),
    //   ]);

    //   change(null, status: RxStatus.success());
    // } catch (e) {
    //   logger.e("[DEV_DEBUG] Error fetching gamebook: $e");
    //   change(null, status: RxStatus.error("Error fetching gamebook"));
    // }
  }

  void updateCurrentGamebook(int id) {
    fetchGamebookData(id);
  }

  void makeDecision(Choice decision) async {
    if (isDevelopmentMode) {
      // In development mode, skip location verification
      _processDecision(decision);
    } else {
      // In production mode, require location verification
      showPostDecisionMessage.value = true;
      hasArrivedAtLocation.value = false;
      _processDecision(decision);
    }
  }

  void _processDecision(Choice decision) async {
    if (currentStep.value != null && currentGamebook.value != null) {
      try {
        // Make the decision through the API
        final response = await gameService.makeDecision(
            currentGamebook.value!.id, decision.nextStepId);

        logger.d("[DEV_DEBUG] Decision response: $response");

        // Fetch updated history after making the decision
        await fetchGameHistory(currentGamebook.value!.id);

        // Update the current step from the response
        if (response['step'] != null) {
          final step = response['step'];

          // Check for end of game in the response
          if (step['title'] == 'EOG' && step['text'] == 'END_OF_GAME') {
            logger.i("[DEV_DEBUG] Game has ended after decision");
            isGameEnded.value = true;
            currentStep.value = Step(
              id: 0,
              title: 'Game Over',
              text: 'Congratulations! You have completed the game.',
              latitude: 0.0,
              longitude: 0.0,
              choices: [],
            );
            // Fetch final history update
            await fetchGameHistory(currentGamebook.value!.id);
            return;
          }

          final newStep = stepFromJson(step);
          currentStep.value = newStep;
          logger.i("[DEV_DEBUG] Updated step from decision response: $newStep");
        } else {
          // If no step in response, fetch the next step
          await fetchCurrentStep(currentGamebook.value!.id);
        }
      } catch (e) {
        logger.e("[DEV_DEBUG] Error processing decision: $e");
        throw Exception("Failed to process decision: $e");
      }
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

  void onReturnToSelection() {
    isGameEnded.value = false;
    currentStep.value = null;
    Get.offNamed('/game-selection');
  }

  @override
  void onClose() {
    // ... existing code ...
  }
}
