// This screen allows searching across different entities
// like players, gamebooks, or cities.
import 'package:get/get.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/models/search_result.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/services/search_service.dart';
import 'package:logger/logger.dart';

class SearchController extends GetxController with StateMixin<SearchResult> {
  static const userFilter = 'user';
  static const scenarioFilter = 'scenario';
  static const lobbyFilter = 'lobby';

  final SearchService searchService;
  final logger = Get.find<Logger>();

  var query = ''.obs; // Reactive query for search
  final RxList<String> selectedFilters = <String>[].obs;

  SearchController({required this.searchService});

  @override
  void onInit() {
    super.onInit();
    change(
      SearchResult(users: [], scenarios: [], lobbies: []),
      status: RxStatus.success(),
    );
    // Load initial items
    searchItems('');
  }

  void updateQuery(String value) {
    query.value = value;
    searchItems(value);
  }

  // Update search logic
  Future<void> searchItems(String query) async {
    try {
      change(null, status: RxStatus.loading());

      final List<Future> futures = [];
      List<User> userResults = [];
      List<Scenario> scenarioResults = [];
      List<Lobby> lobbyResults = [];

      if (selectedFilters.isEmpty || selectedFilters.contains(userFilter)) {
        futures.add(searchService
            .searchUsers(query)
            .then((users) => userResults = users));
      }

      if (selectedFilters.isEmpty || selectedFilters.contains(scenarioFilter)) {
        futures.add(searchService
            .searchScenarios(query)
            .then((scenarios) => scenarioResults = scenarios));
      }

      await Future.wait(futures);
      if (selectedFilters.isEmpty || selectedFilters.contains(lobbyFilter)) {
        futures.add(searchService
            .searchLobbies(query)
            .then((lobbies) => lobbyResults = lobbies));
      }

      await Future.wait(futures);

      change(
        SearchResult(
            users: userResults,
            scenarios: scenarioResults,
            lobbies: lobbyResults
            ),
        status: RxStatus.success(),
      );
    } catch (e) {
      logger.e('Search failed: $e');
      change(null, status: RxStatus.error("Failed to load items: $e"));
    }
  }
}
