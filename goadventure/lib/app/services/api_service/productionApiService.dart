import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductionApiService extends ApiService {
  static const String name = "https://squid-app-p63zw.ondigitalocean.app";

  // Authentication endpoints
  static const String registerRoute = '/api/auth/register';
  static const String loginRoute = '/api/auth/login';
  static const String logoutRoute = '/api/auth/logout';
  static const String refreshTokenRoute = '/api/auth/refresh';

  // User endpoints
  static const String getUserProfileRoute = '/api/user/:id';
  static const String getCurrentUserProfileRoute = '/api/users/profile';
  static const String updateProfileRoute = '/api/users/profile';
  static const String getUsersListRoute = '/api/user/all';
  static const String removeAccountRoute = '/api/users/:id';

  // Scenario endpoints
  static const String getAvailableGamebooksRoute = '/api/scenarios';
  static const String getGameBookWithIdRoute = '/api/scenarios/:id';
  static const String removeScenarioRoute = '/api/scenarios/:id';

  // Game endpoints
  static const String createGameRoute = '/api/games';
  static const String getGameWithIdRoute = '/api/games/:id';
  static const String getNearbyGamesRoute = '/api/games/:id';
  static const String getStepRoute = '/api/games/:id/step';
  static const String makeStepRoute = '/api/games/:id/step';

  @override
  Future<List<Map<String, dynamic>>> getAvailableGamebooks() {
    // TODO: implement getAvailableGamebooks
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getGameBookWithId(int gamebookId) {
    // TODO: implement getGameBookWithId
    throw UnimplementedError();
  }

  // TODO: add logger to log all network activity
  @override
  Future<Map<String, dynamic>> getUserProfile(String id) async {
    try {
      final endpoint = '$name${getUserProfileRoute.replaceAll(':id', id)}';
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        // Convert JSON to Map<String, dynamic>
        final dynamic parsed = jsonDecode(response.body);
        final userData = Map<String, dynamic>.from(parsed);

        return {
          'id': userData['id_user']?.toString() ?? '0',
          'name': userData['login']?.toString() ?? 'Unknown User',
          'email': userData['email']?.toString() ?? '',
          'bio': userData['bio']?.toString() ?? '',
          'gamesPlayed': (userData['gamesPlayed'] as int?) ?? 0,
          'gamesFinished': (userData['gamesFinished'] as int?) ?? 0,
          'preferences':
              Map<String, dynamic>.from(userData['preferences'] ?? {}),
          'avatar': userData['avatar']?.toString() ?? '',
        };
      } else {
        throw Exception(
            'Failed to load profile. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Profile fetch failed: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> search(
      String query, String category) async {
    try {
      if (category == 'user') {
        final response = await http.get(
          Uri.parse('$name$getUsersListRoute?search=$query'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> users = jsonDecode(response.body);
          return users
              .map<Map<String, dynamic>>((user) => {
                    'name': user['login'] ?? 'Unknown User',
                    'type': 'user',
                    'id': user['id_user'].toString(),
                  })
              .toList();
        } else {
          throw Exception(
              'User search failed with status: ${response.statusCode}');
        }
      }

      // Return empty lists for other categories until implemented
      return [];
    } catch (e) {
      throw Exception('Search failed: ${e.toString()}');
    }
  }
}
