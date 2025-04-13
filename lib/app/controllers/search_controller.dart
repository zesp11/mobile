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

      List<User> userResults = [];
      List<Scenario> scenarioResults = [];
      List<Lobby> lobbyResults = [];

      if (selectedFilters.isEmpty || selectedFilters.contains(userFilter)) {
        userResults = await searchService.searchUsers(query);
      }

      if (selectedFilters.isEmpty || selectedFilters.contains(scenarioFilter)) {
        scenarioResults = await searchService.searchScenarios(query);
      }

      if (selectedFilters.isEmpty || selectedFilters.contains(lobbyFilter)) {
        lobbyResults = await searchService.searchLobbies(query);
      }

      change(
        SearchResult(users: userResults, scenarios: scenarioResults, lobbies: lobbyResults),
        status: RxStatus.success(),
      );
    } catch (e) {
      change(null, status: RxStatus.error("Failed to load items: $e"));
    }
  }
}
