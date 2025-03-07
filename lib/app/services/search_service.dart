import 'package:get/get.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:logger/web.dart';

class SearchService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  SearchService({required this.apiService});

  Future<List<Map<String, String>>> searchUsers(String query) async {
    try {
      final response = await apiService.searchUsers(query);
      return _processUserResults(response);
    } catch (error) {
      logger.e("User search error: $error");
      return [];
    }
  }

  Future<List<Map<String, String>>> searchScenarios(String query) async {
    try {
      final response = await apiService.searchScenarios(query);
      return _processScenarioResults(response);
    } catch (error) {
      logger.e("Scenario search error: $error");
      return [];
    }
  }

  List<Map<String, String>> _processUserResults(List<dynamic> response) {
    return response
        .map((item) => {
              'name': (item['name'] ?? '').toString(),
              'type': 'user',
              'id': (item['id'] ?? '').toString(),
            })
        .toList();
  }

  List<Map<String, String>> _processScenarioResults(List<dynamic> response) {
    return response
        .map((item) => {
              'name': (item['name'] ?? '').toString(),
              'type': 'scenario',
              'id': (item['id'] ?? '').toString(),
            })
        .toList();
  }
}
