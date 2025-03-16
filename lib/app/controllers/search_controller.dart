// This screen allows searching across different entities
// like players, gamebooks, or cities.
import 'package:get/get.dart';
import 'package:gotale/app/services/search_service.dart';
import 'package:logger/logger.dart';

class SearchController extends GetxController
    with StateMixin<List<Map<String, String>>> {
  final SearchService searchService;
  final logger = Get.find<Logger>();

  var query = ''.obs; // Reactive query for search

  // List of filtered items based on the query
  Rx<List<Map<String, String>>> filteredItems =
      Rx<List<Map<String, String>>>([]);

  // List of all available items to show initially
  Rx<List<Map<String, String>>> allItems = Rx<List<Map<String, String>>>([]);

  // List of selected filters
  Rx<List<String>> selectedFilters = Rx<List<String>>([]);

  SearchController({required this.searchService});

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty state
    change([], status: RxStatus.success());
    // Load initial items
    searchItems('');
  }

  // Update the query value and perform search
  void updateQuery(String value) {
    query.value = value;
    searchItems(value); // Trigger search when query changes
  }

  // Fetch all items or filter based on the query
  Future<void> searchItems(String query) async {
    try {
      // Only show loading state if we don't have any items yet
      if (state == null || state!.isEmpty) {
        change(null, status: RxStatus.loading());
      }

      List<Map<String, String>> results = [];
      final filters = selectedFilters.value;

      // Debug logging
      logger.d('Current filters: $filters');
      logger.d('Current query: $query');

      // Only search for selected types
      if (filters.isEmpty || filters.contains('user'.tr)) {
        logger.d('Searching for users...');
        final userResults = await searchService.searchUsers(query);
        logger.d('Found ${userResults.length} users');
        results.addAll(userResults);
      }

      if (filters.isEmpty || filters.contains('scenario'.tr)) {
        logger.d('Searching for scenarios...');
        final scenarioResults = await searchService.searchScenarios(query);
        logger.d('Found ${scenarioResults.length} scenarios');
        results.addAll(scenarioResults);
      }

      logger.d('Total results: ${results.length}');
      allItems.value = results;
      filteredItems.value = results;
      change(results, status: RxStatus.success());
    } catch (e) {
      logger.e('Search error: $e');
      change(null, status: RxStatus.error("Failed to load items: $e"));
    }
  }

  // Filter items based on the selected filters
  void filterItemsByTypes(RxList<String> filters) {
    logger.d('Setting filters to: $filters');
    selectedFilters.value = filters;
    searchItems(query.value); // Re-search with current query and new filters
  }
}
