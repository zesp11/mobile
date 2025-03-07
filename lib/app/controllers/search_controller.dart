// This screen allows searching across different entities
// like players, gamebooks, or cities.
import 'package:get/get.dart';
import 'package:gotale/app/services/search_service.dart';
import 'package:gotale/main.dart';

class SearchController extends GetxController
    with StateMixin<List<Map<String, String>>> {
  final SearchService searchService;

  var query = ''.obs; // Reactive query for search

  // List of filtered items based on the query
  Rx<List<Map<String, String>>> filteredItems =
      Rx<List<Map<String, String>>>([]);

  // List of all available items to show initially
  Rx<List<Map<String, String>>> allItems = Rx<List<Map<String, String>>>([]);

  // List of selected filters
  Rx<List<String>> selectedFilters = Rx<List<String>>([]);

  SearchController({required this.searchService});

  // Update the query value and perform search
  void updateQuery(String value) {
    query.value = value;
    searchItems(value); // Trigger search when query changes
  }

  // Fetch all items or filter based on the query
  Future<void> searchItems(String query) async {
    try {
      change(null, status: RxStatus.loading());

      List<Map<String, String>> results = [];
      final filters = selectedFilters.value;

      // Debug logging
      print('Current filters: $filters');
      print('Current query: $query');

      // Only search for selected types
      if (filters.isEmpty || filters.contains('user'.tr)) {
        print('Searching for users...');
        final userResults = await searchService.searchUsers(query);
        print('Found ${userResults.length} users');
        results.addAll(userResults);
      }

      if (filters.isEmpty || filters.contains('scenario'.tr)) {
        print('Searching for scenarios...');
        final scenarioResults = await searchService.searchScenarios(query);
        print('Found ${scenarioResults.length} scenarios');
        results.addAll(scenarioResults);
      }

      print('Total results: ${results.length}');
      allItems.value = results;
      filteredItems.value = results;
      change(results, status: RxStatus.success());
    } catch (e) {
      print('Search error: $e');
      change(null, status: RxStatus.error("Failed to load items: $e"));
    }
  }

  // Filter items based on the selected filters
  void filterItemsByTypes(RxList<String> filters) {
    print('Setting filters to: $filters');
    selectedFilters.value = filters;
    searchItems(query.value); // Re-search with current query and new filters
  }
}
