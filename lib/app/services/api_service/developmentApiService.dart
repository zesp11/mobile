import 'package:get/get.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:gotale/app/services/api_service/mockData.dart';
import 'package:logger/web.dart'; // HTTP library

// TODO: improve development service (maybe sqlite?)
class DevelopmentApiService implements ApiService {
  final logger = Get.find<Logger>();
  final Duration delay;

  DevelopmentApiService({required this.delay});

  @override
  Future<Map<String, dynamic>> getUserProfile(String id) async {
    await Future.delayed(delay); // delay for development

    // Returning mock user profile data
    // TODO: check if id is in range and check in future if production returned 404
    try {
      // Try to find the user with the given id
      var result = mockUsers.firstWhere((user) => user.id == id);

      // Return the user's profile as a map
      return result
          .toJson(); // Assuming your UserProfile class has toJson method
    } catch (e) {
      // Print the error and return a custom error message
      logger.w('User with id $id not found.');
      throw Exception('User not found');
    }
  }

  @override
  Future<List> search(String query, String category) async {
    await Future.delayed(delay);

    // TODO: keep that data inside one place (maybe sqlite db?)
    List<Map<String, String>> allItems = [];

    // Loop through mockUsers and add items to allItems
    for (var user in mockUsers) {
      allItems.add({
        'name': user.name,
        'type': 'user',
        'id': user.id,
      });
    }
    // Loop through mockGamebooksJson and add items to allItems
    for (var gamebook in mockGamebooksJson) {
      allItems.add({
        'name': gamebook["title"],
        'type': 'scenario',
        'id': gamebook["id"].toString(),
      });
    }

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

  // Helper function to retrieve the current gamebook's steps
  Future<List<Map<String, dynamic>>> getGameSteps() async {
    await Future.delayed(delay); // delay for development

    return mockGamebooksJson[id]['steps'];
  }

  // Helper function to get a specific step by its ID
  Future<Map<String, dynamic>> getStepById(int stepId) async {
    await Future.delayed(delay); // delay for development

    final steps = mockGamebooksJson[id]['steps'];
    return steps.firstWhere((step) => step['id'] == stepId, orElse: () => {});
  }

  Future<Map<String, dynamic>> getGameBookWithId(int id) async {
    await Future.delayed(delay); // delay for development

    return mockGamebooksJson[id];
  }

  Future<List<Map<String, dynamic>>> getAvailableGamebooks() async {
    await Future.delayed(delay); // delay for development

    return mockGamebooksJson;
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> register(String username, String password, String email) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }

  @override
  Future<List> searchScenarios(String query) {
    // TODO: implement searchScenarios
    throw UnimplementedError();
  }

  @override
  Future<List> searchUsers(String query) {
    // TODO: implement searchUsers
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserProfile(Map<String, dynamic> profile) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getCurrentUserProfile() {
    // TODO: implement getCurrentUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> createGameFromScenario(int scenarioId) {
    // TODO: implement createGameFromScenario
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getCurrentStep(int gameId) {
    // TODO: implement getCurrentStep
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getGamePlay(int gameId) {
    // TODO: implement getGamePlay
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getGamesInProgress() async {
    await Future.delayed(delay); // delay for development

    // Return mock data for games in progress
    return [
      {
        'id': 1,
        'scenarioId': 1,
        'scenarioName': 'The Lost City',
        'currentStep': 3,
        'totalSteps': 10,
        'startedAt':
            DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'lastPlayedAt':
            DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 2,
        'scenarioId': 2,
        'scenarioName': 'Mystery of the Ancient Temple',
        'currentStep': 1,
        'totalSteps': 8,
        'startedAt':
            DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        'lastPlayedAt':
            DateTime.now().subtract(Duration(hours: 5)).toIso8601String(),
      },
    ];
  }
}
