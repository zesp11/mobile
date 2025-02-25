import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

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

  // @override
  // Future<List<Map<String, dynamic>>> getAvailableGamebooks() async {
  //   try {
  //     final endpoint = '$name$getAvailableGamebooksRoute';
  //     // Add logging for network activity
  //     // Get.find<Logger>().d('Fetching gamebooks from: $endpoint');

  //     final response = await http.get(Uri.parse(endpoint));

  //     // Add response logging
  //     // Get.find<Logger>().d('Gamebooks response: ${response.statusCode}');

  //     if (response.statusCode == 200) {
  //       final List<dynamic> gamebooks = jsonDecode(response.body);
  //       // TODO:
  //       // return gamebooks.map<Map<String, dynamic>>((gamebook) {
  //       //   return {
  //       //     'id': gamebook['id_scenario']?.toString() ?? '0',
  //       //     'title': gamebook['title']?.toString() ?? 'Untitled Scenario',
  //       //     'description': gamebook['description']?.toString() ?? '',
  //       //     'coverImage': gamebook['cover_image']?.toString() ?? '',
  //       //     'difficulty': gamebook['difficulty']?.toString() ?? 'medium',
  //       //     'estimatedDuration': (gamebook['estimated_duration'] as int?) ?? 60,
  //       //     'averageRating':
  //       //         (gamebook['average_rating'] as num?)?.toDouble() ?? 0.0,
  //       //     'totalPlays': (gamebook['total_plays'] as int?) ?? 0,
  //       //     'author': gamebook['author']?.toString() ?? 'Unknown Author',
  //       //     'createdAt': gamebook['created_at']?.toString() ?? '',
  //       //   };
  //       // }).toList();
  //       return gamebooks.map<Map<String, dynamic>>((gamebook) {
  //         return {
  //           'id': gamebook['id_scenario']?.toString() ?? '0',
  //           'title': gamebook['title']?.toString() ?? 'Untitled Scenario',
  //           'description': gamebook['description']?.toString() ?? '',
  //           'coverImage': gamebook['cover_image']?.toString() ?? '',
  //           'difficulty': gamebook['difficulty']?.toString() ?? 'medium',
  //           'estimatedDuration': (gamebook['estimated_duration'] as int?) ?? 60,
  //           'averageRating':
  //               (gamebook['average_rating'] as num?)?.toDouble() ?? 0.0,
  //           'totalPlays': (gamebook['total_plays'] as int?) ?? 0,
  //           'author': gamebook['author']?.toString() ?? 'Unknown Author',
  //           'createdAt': gamebook['created_at']?.toString() ?? '',
  //         };
  //       }).toList();
  //     } else {
  //       throw Exception(
  //           'Failed to load gamebooks. Status: ${response.statusCode}');
  //     }
  //   } on http.ClientException catch (e) {
  //     // Get.find<Logger>().e('Network error fetching gamebooks: ${e.message}');
  //     throw Exception('Network error: ${e.message}');
  //   } on FormatException catch (e) {
  //     // Get.find<Logger>().e('JSON parsing error: ${e.message}');
  //     throw Exception('Data format error: ${e.message}');
  //   } catch (e) {
  //     // Get.find<Logger>().e('Unexpected error: ${e.toString()}');
  //     throw Exception('Failed to fetch gamebooks: ${e.toString()}');
  //   }
  // }

  @override
  Future<List<Map<String, dynamic>>> getAvailableGamebooks() async {
    try {
      final endpoint = '$name$getAvailableGamebooksRoute';
      final logger = Get.find<Logger>();

      // Add debug logging
      logger.d('Fetching gamebooks from: $endpoint');

      // Add authorization if needed
      final headers = {
        'Content-Type': 'application/json',
        // TODO: 'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      };

      final response = await http.get(
        Uri.parse(endpoint),
        headers: headers,
      );

      logger.d('Gamebooks response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> gamebooks = responseBody['data'] ?? [];

        final gamebooksResponse =
            gamebooks.map<Map<String, dynamic>>((gamebook) {
          // Extract author information
          final authorData = gamebook['author'] ?? {};

          // Map API response to Gamebook structure
          return {
            'id': gamebook['id'] ?? 0,
            'title': gamebook['name']?.toString() ?? 'Untitled Scenario',
            'description': gamebook['description']?.toString() ??
                'No description available',
            'startDate': _parseDateTime(gamebook['created_at']),
            'endDate': _parseDateTime(gamebook['end_date']),
            'steps': _parseSteps(gamebook['steps'] ?? []),
            'authorId': _parseAuthorId(authorData),
            // Add additional fields if needed
            'difficulty': gamebook['difficulty']?.toString() ?? 'medium',
            'coverImage': gamebook['cover_image']?.toString() ?? '',
          };
        }).toList();

        return gamebooksResponse;
      } else {
        logger.e('Failed to load gamebooks. Status: ${response.statusCode}');
        throw Exception('Failed to load gamebooks: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      Get.find<Logger>().e('Network error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      Get.find<Logger>().e('JSON parsing error: ${e.message}');
      throw Exception('Invalid data format: ${e.message}');
    } catch (e) {
      Get.find<Logger>().e('Unexpected error: $e');
      throw Exception('Failed to fetch gamebooks: $e');
    }
  }

// Helper methods
  DateTime _parseDateTime(String? dateString) {
    if (dateString == null) return DateTime.now();
    return DateTime.tryParse(dateString) ?? DateTime.now();
  }

  List<Map<String, dynamic>> _parseSteps(dynamic stepsData) {
    if (stepsData is! List) return [];
    return stepsData.map<Map<String, dynamic>>((step) {
      return {
        'id': step['id_step']?.toString() ?? '0',
        'title': step['title']?.toString() ?? 'Untitled Step',
        'content': step['content']?.toString() ?? '',
        // Add other step fields as needed
      };
    }).toList();
  }

  int _parseAuthorId(dynamic authorData) {
    if (authorData is Map<String, dynamic>) {
      return authorData['id_author'] as int? ?? 0;
    }
    return 0;
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
