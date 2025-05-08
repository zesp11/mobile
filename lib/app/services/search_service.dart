import 'package:get/get.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:logger/web.dart';

class SearchService extends GetxService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  SearchService({required this.apiService});

  Future<List<User>> searchUsers(String query) async {
    try {
      return apiService.searchUsers(query);
    } catch (error) {
      logger.e("User search error: $error");
      return [];
    }
  }

  Future<List<Scenario>> searchScenarios(String query) async {
    try {
      return apiService.searchScenarios(query);
    } catch (error) {
      logger.e("Scenario search error: $error");
      return [];
    }
  }

  Future<List<Lobby>> searchLobbies(String query) async {
    try {
      return apiService.searchLobbies(query);
    } catch (error) {
      logger.e("Lobby search error: $error");
      return [];
    }
  }

  // List<Map<String, String>> _processUserResults(List<dynamic> response) {
  //   return response
  //       .map((item) => {
  //             'name': (item['name'] ?? '').toString(),
  //             'type': 'user',
  //             'id': (item['id'] ?? '').toString(),
  //           })
  //       .toList();
  // }

  // List<Map<String, String>> _processScenarioResults(List<dynamic> response) {
  //   return response
  //       .map((item) => {
  //             'name': (item['name'] ?? '').toString(),
  //             'type': 'scenario',
  //             'id': (item['id'] ?? '').toString(),
  //           })
  //       .toList();
  // }
}
