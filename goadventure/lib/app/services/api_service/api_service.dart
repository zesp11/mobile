import 'package:http/http.dart' as http;
import 'dart:convert';

// Centralized service for interacting with the backend.
// TODO: this slowly should be transfered to be only interface
// as base class for development ApiService and ProductionApiService
abstract class ApiService {
  final String baseUrl = "https://api.example.com";

  // Fetch games that can be resumed
  Future<List<dynamic>> getResumeGames() async {
    var response = await http.get(Uri.parse('$baseUrl/games/resume'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch resume games");
    }
  }

  // Fetch new gamebooks
  Future<List<dynamic>> getNewGamebooks() async {
    var response = await http.get(Uri.parse('$baseUrl/gamebooks/new'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch new gamebooks");
    }
  }

  // Fetch nearby gamebooks based on user location
  Future<List<dynamic>> getNearbyGamebooks(Map<String, double> location) async {
    var response = await http.get(
      Uri.parse(
          '$baseUrl/gamebooks/nearby?lat=${location['lat']}&lon=${location['lon']}'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch nearby gamebooks");
    }
  }

  // Fetch details of a specific game
  Future<Map<String, dynamic>> getGameDetails(String gameId) async {
    var response = await http.get(Uri.parse('$baseUrl/games/$gameId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch game details");
    }
  }

  // Submit a decision for a game
  Future<void> submitDecision(String gameId, String decision) async {
    var response = await http.post(
      Uri.parse('$baseUrl/games/$gameId/decision'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'decision': decision}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to submit decision");
    }
  }

  // Check the decision status for the current game
  Future<String> getDecisionStatus(String gameId) async {
    var response = await http.get(Uri.parse('$baseUrl/games/$gameId/status'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['status'];
    } else {
      throw Exception("Failed to fetch decision status");
    }
  }

  // Fetch user profile details
  Future<Map<String, dynamic>> getUserProfile();

  // Update user profile details
  Future<void> updateUserProfile(Map<String, dynamic> profile) async {
    var response = await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profile),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update user profile");
    }
  }

  // Search functionality for players, gamebooks, and cities
  Future<List<dynamic>> search(String query, String category) async {
    var response = await http.get(
      Uri.parse('$baseUrl/search?query=$query&category=$category'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Search failed");
    }
  }

  Future<Map<String, dynamic>> getData(String url);
}
