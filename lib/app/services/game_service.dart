import 'package:get/get.dart';
import 'package:gotale/app/models/gamebook.dart';
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
}
