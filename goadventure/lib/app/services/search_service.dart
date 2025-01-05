import 'package:goadventure/app/services/api_service/api_service.dart';

class SearchService {
  final ApiService apiService;

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
      print("Search error: $error");
      return [];
    }
  }
}
