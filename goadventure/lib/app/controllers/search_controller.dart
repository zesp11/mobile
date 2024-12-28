// This screen allows searching across different entities
// like players, gamebooks, or cities.
import 'package:get/get.dart';
import 'package:goadventure/app/services/search_service.dart';

// class SearchController extends GetxController {
//   final ApiService apiService = Get.find();

//   // Observables
//   var searchResults = [].obs;

//   void search(String query, String category) async {
//     // searchResults.value = await apiService.search(query, category);
//   }
// }

class SearchController extends GetxController {
  final SearchService searchService; // Declare the SearchService dependency

  // Reactive query for search
  var query = ''.obs;

  // TODO: add types instead of Map<String, String>
  // List of filtered items based on the query
  Rx<List<Map<String, String>>> filteredItems =
      Rx<List<Map<String, String>>>([]);

  // Constructor accepting SearchService
  SearchController({required this.searchService});

  // Update the query value
  void updateQuery(String value) {
    query.value = value;
    searchItems(value); // Trigger search when query changes
  }

  // Perform the search by calling the SearchService
  Future<void> searchItems(String query) async {
    // Optionally: You can also pass a category as an argument
    // TODO: make the categories enum
    var results = await searchService.search(
        query, 'all'); // Example: Search across all categories
    filteredItems.value = results;
  }
}
