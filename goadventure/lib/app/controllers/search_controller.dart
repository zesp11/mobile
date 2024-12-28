// This screen allows searching across different entities
// like players, gamebooks, or cities.
import 'package:get/get.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';

// class SearchController extends GetxController {
//   final ApiService apiService = Get.find();

//   // Observables
//   var searchResults = [].obs;

//   void search(String query, String category) async {
//     // searchResults.value = await apiService.search(query, category);
//   }
// }

class SearchController extends GetxController {
  final ApiService apiService; // Declare the ApiService dependency

  // List of all items (this would be fetched from the database in a real app)
  final List<Map<String, String>> _allItems = [
    {'name': 'Alice', 'type': 'User'},
    {'name': 'Bob', 'type': 'User'},
    {'name': 'Chess Master', 'type': 'Game'},
    {'name': 'Zombie Escape', 'type': 'Scenario'},
    {'name': 'Charlie', 'type': 'User'},
    {'name': 'Space Adventure', 'type': 'Game'},
    {'name': 'Desert Survival', 'type': 'Scenario'},
  ];

  // Reactive query
  var query = ''.obs;

  // Filtered items based on query
  List<Map<String, String>> get filteredItems {
    return _allItems
        .where((item) =>
            item['name']!.toLowerCase().contains(query.value.toLowerCase()))
        .toList();
  }

  // Constructor accepting ApiService
  SearchController({required this.apiService});

  // Update the query value
  void updateQuery(String value) {
    query.value = value;
  }
}
