// This screen allows searching across different entities
// like players, gamebooks, or cities.
import 'package:get/get.dart';
import 'package:gotale/app/models/search_result.dart';
import 'package:gotale/app/services/search_service.dart';
import 'package:logger/logger.dart';

class SearchController extends GetxController with StateMixin<SearchResult> {
  final SearchService searchService;
  final logger = Get.find<Logger>();

  var query = ''.obs; // Reactive query for search
  Rx<List<String>> selectedFilters = Rx<List<String>>([]);

  SearchController({required this.searchService});

  @override
  void onInit() {
    super.onInit();
    change(
      SearchResult(users: [], scenarios: []),
      status: RxStatus.success(),
    );
    // Load initial items
    searchItems('');
  }

  void updateQuery(String value) {
    query.value = value;
    searchItems(value);
  }

  // Fetch all items or filter based on the query
  Future<void> searchItems(String query) async {
    try {
      change(null, status: RxStatus.loading());

      final filters = selectedFilters.value;

      // Debug logging
      logger.d('Current filters: $filters');
      logger.d('Current query: $query');

      // // Only search for selected types
      // if (filters.isEmpty || filters.contains('user'.tr)) {
      //   logger.d('Searching for users...');
      //   final userResults = await searchService.searchUsers(query);
      // logger.d('Found ${userResults.length} users');
      //   filteredUsers.value.addAll(userResults);
      // }

      // if (filters.isEmpty || filters.contains('scenario'.tr)) {
      //   logger.d('Searching for scenarios...');
      //   final scenarioResults = await searchService.searchScenarios(query);
      //   logger.d('Found ${scenarioResults.length} scenarios');
      //   results.addAll(scenarioResults);
      // }

      // logger.d('Total results: ${results.length}');
      // allItems.value = results;
      // filteredItems.value = results;

      final userResults = await searchService.searchUsers(query);
      logger.d('Found ${userResults.length} users');
      final scenarioResults = await searchService.searchScenarios(query);
      logger.d('Found ${scenarioResults.length} scenarios');
      change(
        SearchResult(users: userResults, scenarios: scenarioResults),
        status: RxStatus.success(),
      );
    } catch (e) {
      logger.e('Search error: $e');
      change(null, status: RxStatus.error("Failed to load items: $e"));
    }
  }
}
