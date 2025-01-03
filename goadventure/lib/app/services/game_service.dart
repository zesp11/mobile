import 'package:goadventure/app/models/decision.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/models/step.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';

class GameService {
  final ApiService apiService;

  GameService({required this.apiService});

  // Fetch a single Gamebook
  Future<Gamebook> fetchGamebook(int id) async {
    try {
      // TODO: handlde/display it if game not found
      final response = await apiService.getGameBookWithId(id);
      return Gamebook.fromJson(
          response); // Assuming Gamebook has a fromJson method
    } catch (e) {
      throw Exception("Error fetching gamebook: $e");
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
      print("gameServiceError fetching gamebooks: $e");
      return [];
    }
  }
}
