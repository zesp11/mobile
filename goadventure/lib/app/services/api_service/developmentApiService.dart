import 'package:goadventure/app/services/api_service/api_service.dart';

class DevelopmentApiService implements ApiService {
  @override
  // TODO: implement baseUrl
  String get baseUrl => throw UnimplementedError();

  @override
  getData(String url) {
    // TODO: implement getData
    throw UnimplementedError();
  }

  @override
  Future<String> getDecisionStatus(String gameId) {
    // TODO: implement getDecisionStatus
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getGameDetails(String gameId) {
    // TODO: implement getGameDetails
    throw UnimplementedError();
  }

  @override
  Future<List> getNearbyGamebooks(Map<String, double> location) {
    // TODO: implement getNearbyGamebooks
    throw UnimplementedError();
  }

  @override
  Future<List> getNewGamebooks() {
    // TODO: implement getNewGamebooks
    throw UnimplementedError();
  }

  @override
  Future<List> getResumeGames() {
    // TODO: implement getResumeGames
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getUserProfile() async {
    // TODO: (should we in development API?)
    // Simulate a network delay
    await Future.delayed(Duration(milliseconds: 500));

    // Returning mock user profile data
    return {
      "id": "12345",
      "name": "John Doe",
      "email": "johndoe@example.com",
      "avatar": "", // No avatar provided
      "bio": "Just a mock user for development purposes.",
      "gamesPlayed": 50, // Example data
      "gamesFinished": 30, // Example data
      "preferences": {
        "theme": "dark",
        "notifications": true,
      },
    };
  }

  @override
  Future<List> search(String query, String category) async {
    // Example: Search across all items (you could adjust based on category)
    // Simulating a search result from a local mock data
    List<Map<String, String>> allItems = [
      {'name': 'Alice', 'type': 'User'},
      {'name': 'Bob', 'type': 'User'},
      {'name': 'Chess Master', 'type': 'Game'},
      {'name': 'Zombie Escape', 'type': 'Scenario'},
      {'name': 'Charlie', 'type': 'User'},
      {'name': 'Space Adventure', 'type': 'Game'},
      {'name': 'Desert Survival', 'type': 'Scenario'},
    ];

    // Filter based on query and category (you can adjust the filtering logic here)
    return allItems.where((item) {
      bool matchesQuery =
          item['name']!.toLowerCase().contains(query.toLowerCase());
      if (category != 'all') {
        return matchesQuery && item['type'] == category;
      }
      return matchesQuery;
    }).toList();
  }

  @override
  Future<void> submitDecision(String gameId, String decision) {
    // TODO: implement submitDecision
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserProfile(Map<String, dynamic> profile) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}
