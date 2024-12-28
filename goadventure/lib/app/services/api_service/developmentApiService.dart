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
  Future<List> search(String query, String category) {
    // TODO: implement search
    throw UnimplementedError();
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
