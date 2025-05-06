import 'package:get/get.dart';
import 'package:gotale/app/models/game_created.dart';
import 'package:gotale/app/models/game.dart';
import 'package:gotale/app/models/game_history_record.dart';
import 'package:gotale/app/models/game_in_progress.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/models/game_step.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:logger/web.dart';

class GameService extends GetxService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  GameService({required this.apiService});

  // Fetch a single Gamebook
  Future<Scenario> fetchGamebook(int id) async {
    try {
      return await apiService.getScenarioWithId(id);
    } catch (e) {
      throw Exception("Error fetching gamebook: $e");
    }
  }

  // Fetch scenario details
  Future<Scenario> fetchScenarioDetails(int scenarioId) async {
    try {
      return await apiService.getScenarioWithId(scenarioId);
    } catch (e) {
      throw Exception("Error fetching scenario details: $e");
    }
  }

  // Fetch multiple Gamebooks
  Future<List<Scenario>> fetchMultipleGamebooks(List<int> ids) async {
    try {
      // Fetch all Gamebooks concurrently
      return await Future.wait(ids.map((id) => fetchGamebook(id)));
    } catch (e) {
      throw Exception("Error fetching multiple gamebooks: $e");
    }
  }

  Future<List<Scenario>> fetchAvailableGamebooks() async {
    try {
      // Fetch the raw data from the API service
      return await apiService.getAvailableGamebooks();
    } catch (e) {
      // Handle errors gracefully
      logger.e("gameServiceError fetching gamebooks: $e");
      return [];
    }
  }

  Future<GameCreated> createGameFromScenario(int scenarioId) async {
    try {
      return await apiService.createGameFromScenario(scenarioId);
    } catch (e) {
      logger.e("Error creating game from scenario: $e");
      throw Exception("Failed to create game from scenario: $e");
    }
  }

  Future<GameStep> getCurrentStep(int gameId) async {
    try {
      final step = await apiService.getCurrentStep(gameId);
      return step;
    } catch (e) {
      logger.e("Error getting current step: $e");
      throw Exception("Failed to get current step: $e");
    }
  }

  Future<Game> getGameWithId(int gameId) async {
    try {
      return await apiService.getGameWithId(gameId);
    } catch (e) {
      logger.e("Error getting game play data: $e");
      throw Exception("Failed to get game play data: $e");
    }
  }

  Future<List<GameInProgress>> fetchGamesInProgress(
      {bool includeFinished = false}) async {
    try {
      return apiService.getGamesInProgress(includeFinished: includeFinished);
    } catch (e) {
      logger.e("Error fetching games in progress: $e");
      return [];
    }
  }

  Future<List<GameHistoryRecord>> getGameHistory(int gameId) async {
    try {
      logger.i("[DEV_DEBUG] Fetching game history for game ID: $gameId");
      return await apiService.getGameHistory(gameId);
    } catch (e) {
      logger.e("[DEV_DEBUG] Error fetching game history: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> makeDecision(int gameId, int choiceId) async {
    try {
      logger.i(
          "[DEV_DEBUG] Making decision for game ID: $gameId with choice: $choiceId");
      final response = await apiService.makeDecision(gameId, choiceId);
      logger.d("[DEV_DEBUG] Decision response: $response");
      return response;
    } catch (e) {
      logger.e("[DEV_DEBUG] Error making decision: $e");
      throw Exception("Failed to make decision: $e");
    }
  }

  Future<void> fetchGamebookData(int gameId) async {
    // try {
    throw UnimplementedError("fetchGamebookData");

    // logger.i("[DEV_DEBUG] Fetching gamebook data for game ID: $gameId");
    // final gameData = await apiService.getGamePlay(gameId);

    // Create Gamebook from the response
    // final gamebook = Scenario(
    //   id: gameData['id_game'] ?? 0,
    //   title: gameData['name'] ?? 'Untitled Game',
    //   description: 'Game in progress',
    //   startDate: DateTime.now(),
    //   endDate: null,
    //   steps: [], // We'll populate this with the current step
    //   authorId: gameData['id_author'] ?? 0,
    // );

    // // Handle the current step from the response
    // final step = gameData['first_step'];
    // if (step != null) {
    //   final currentStep = Step(
    //     id: step['id_step'] ?? 1,
    //     title: step['title'] ?? 'Current Step',
    //     text: step['text'] ?? '',
    //     latitude: step['latitude']?.toDouble() ?? 0.0,
    //     longitude: step['longitude']?.toDouble() ?? 0.0,
    //     decisions: (step['choices'] as List?)
    //             ?.map((choice) => choiceFromJson(choice))
    //             .toList() ??
    //         [],
    //   );

    //   gamebook.steps.add(currentStep);
    // }
    // } catch (e) {
    //   logger.e("Error fetching gamebook data: $e");
    //   rethrow;
    // }
  }
}
