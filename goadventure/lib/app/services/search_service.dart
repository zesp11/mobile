import 'package:get/get.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:logger/web.dart';

class SearchService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  SearchService({required this.apiService});

  // Perform search based on query and category
  Future<List<Map<String, String>>> search(
      String query, String category) async {
    try {
      var response = await apiService.search(query, category);

      List<Map<String, String>> results = [];
      for (var item in response) {
        results.add({
          'name': item['name'],
          'type': item['type'],
          'id': item['id'],
        });
      }

      return results;
    } catch (error) {
      logger.e("Search error: $error");
      return [];
    }
  }
}
