import 'package:get/get.dart';
import 'package:gotale/app/models/gamebook.dart';
import 'package:gotale/app/models/decision.dart';
import 'package:gotale/app/models/step.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:logger/web.dart';

class GameService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  GameService({required this.apiService});

  // Fetch a single Gamebook
  Future<Gamebook> fetchGamebook(int id) async {
    try {
      final response = await apiService.getGameBookWithId(id);
      return Gamebook.fromJson(response);
    } catch (e) {
      throw Exception("Error fetching gamebook: $e");
    }
  }

  // Fetch scenario details
  Future<Gamebook> fetchScenarioDetails(int scenarioId) async {
    try {
      final response = await apiService.getGameBookWithId(scenarioId);
      return Gamebook.fromJson(response);
    } catch (e) {
      throw Exception("Error fetching scenario details: $e");
    }
  }

  // Fetch multiple Gamebooks
  Future<List<Gamebook>> fetchMultipleGamebooks(List<int> ids) async {
    try {
      // Fetch all Gamebooks concurrently
      return await Future.wait(ids.map((id) => fetchGamebook(id)));
    } catch (e) {
      throw Exception("Error fetching multiple gamebooks: $e");
    }
  }

  Future<List<Gamebook>> fetchAvailableGamebooks() async {
    try {
      // Fetch the raw data from the API service
      List<Map<String, dynamic>> gamebooksJson =
          await apiService.getAvailableGamebooks();

      // Map the JSON data into a list of Gamebook objects
      return gamebooksJson.map((json) => Gamebook.fromJson(json)).toList();
    } catch (e) {
      // Handle errors gracefully
      logger.e("gameServiceError fetching gamebooks: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> createGameFromScenario(int scenarioId) async {
    try {
      final response = await apiService.createGameFromScenario(scenarioId);
      return response;
    } catch (e) {
      logger.e("Error creating game from scenario: $e");
      throw Exception("Failed to create game from scenario: $e");
    }
  }

  Future<Map<String, dynamic>> getCurrentStep(int gameId) async {
    try {
      final response = await apiService.getCurrentStep(gameId);
      return response;
    } catch (e) {
      logger.e("Error getting current step: $e");
      throw Exception("Failed to get current step: $e");
    }
  }

  Future<Map<String, dynamic>> getGamePlay(int gameId) async {
    try {
      final response = await apiService.getGamePlay(gameId);
      return response;
    } catch (e) {
      logger.e("Error getting game play data: $e");
      throw Exception("Failed to get game play data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchGamesInProgress() async {
    try {
      logger.i("[DEV_DEBUG] Fetching games in progress from API");
      return await apiService.getGamesInProgress();
    } catch (e) {
      logger.e("Error fetching games in progress: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getGameHistory(int gameId) async {
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
    try {
      logger.i("[DEV_DEBUG] Fetching gamebook data for game ID: $gameId");
      final gameData = await apiService.getGamePlay(gameId);

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

      // Handle the current step from the response
      final step = gameData['first_step'];
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

        gamebook.steps.add(currentStep);
      }
    } catch (e) {
      logger.e("Error fetching gamebook data: $e");
      rethrow;
    }
  }
}
