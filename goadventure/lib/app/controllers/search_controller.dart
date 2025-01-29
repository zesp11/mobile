// This screen allows searching across different entities
// like players, gamebooks, or cities.
import 'package:get/get.dart';
import 'package:goadventure/app/services/search_service.dart';
import 'package:goadventure/main.dart';

class SearchController extends GetxController
    with StateMixin<List<Map<String, String>>> {
  final SearchService searchService;

  var query = ''.obs; // Reactive query for search

  // List of filtered items based on the query
  Rx<List<Map<String, String>>> filteredItems =
      Rx<List<Map<String, String>>>([]);

  // List of all available items to show initially
  Rx<List<Map<String, String>>> allItems = Rx<List<Map<String, String>>>([]);

  SearchController({required this.searchService});

  // Update the query value and perform search
  void updateQuery(String value) {
    query.value = value;
    searchItems(value); // Trigger search when query changes
  }

  // Fetch all items or filter based on the query
  Future<void> searchItems(String query) async {
    try {
      change(null, status: RxStatus.loading()); // Set loading status

      List<Map<String, String>> results;

      // If the query is empty, fetch all items
      if (query.isEmpty) {
        // FIXME: switch to categories instead of hard coded user
        results = await searchService.search('', 'user'); // Fetch all items
        allItems.value = results;
      } else {
        results = await searchService.search(
            query, 'user'); // Filter based on the query
      }

      if (!isProduction && query == 'error') {
        throw Exception("Error invoked");
      }

      // Update filteredItems and set success status
      filteredItems.value = results;
      change(results, status: RxStatus.success());
    } catch (e) {
      // Handle errors and set error status
      change(null, status: RxStatus.error("Failed to load items: $e"));
    }
  }

  // Filter items based on the selected filters (e.g., 'User', 'Game', 'Scenario')
  void filterItemsByTypes(RxList<String> selectedFilters) {
    // Get all items
    List<Map<String, String>> filteredList = [];

    // Filter the items based on the selected filter types
    for (var item in allItems.value) {
      if (selectedFilters.isEmpty || selectedFilters.contains(item['type'])) {
        filteredList.add(item);
      }
    }

    // Update filteredItems with the result of filtering
    filteredItems.value = filteredList;

    // Reflect the change in the state
    change(filteredList, status: RxStatus.success());
  }
}
