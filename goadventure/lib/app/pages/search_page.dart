import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:goadventure/app/controllers/search_controller.dart"
    as goAdventureSearch;

/* TODO: getx documentation
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
*/

/* TODO: consider if it should have:
- 3 distinct list 
- one list with additional field for type
*/

class SearchScreen extends GetView<goAdventureSearch.SearchController> {
  // Track selected filters
  final RxList<String> selectedFilters = RxList<String>([]);

  @override
  Widget build(BuildContext context) {
    // Initially load all available items
    controller.searchItems('');

    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for users, games, scenarios...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                controller.updateQuery(value); // Update the query
              },
            ),
          ),

          const SizedBox(height: 8),

          // Filter Buttons Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton("User"),
                _buildFilterButton("Game"),
                _buildFilterButton("Scenario"),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Results Section
          Expanded(
            child: Stack(
              children: [
                // Search Results
                controller.obx(
                  (state) {
                    // If no results found
                    if (state == null || state.isEmpty) {
                      return const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }

                    // Group by 'type' field in the item
                    Map<String, List<Map<String, String>>> groupedItems = {};

                    for (var item in state) {
                      final type = item['type']!;
                      groupedItems.putIfAbsent(type, () => []).add(item);
                    }

                    // Render grouped results
                    return ListView(
                      children: groupedItems.entries.map((entry) {
                        final type = entry.key;
                        final items = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Group Header
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            // List of items in this group
                            ...items.map((item) {
                              return ListTile(
                                leading: _getIconForType(item['type']!),
                                title: Text(
                                  item['name']!,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(item['type']!),
                                onTap: () {
                                  if (item['type'] == 'User') {
                                    Get.toNamed('/profile/${item["id"]}');
                                  } else if (item['type'] == 'Scenario') {
                                    Get.toNamed('/scenario/${item["id"]}');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Selected: ${item['name']}'),
                                      ),
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    );
                  },
                  onLoading: const Center(
                    child: CircularProgressIndicator(), // Show loading spinner
                  ),
                  onError: (error) => Center(
                    child: Text(
                      error ?? 'Error loading results',
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to return an icon based on type
  Icon _getIconForType(String type) {
    switch (type) {
      case 'User':
        return const Icon(Icons.person, color: Colors.blue);
      case 'Game':
        return const Icon(Icons.videogame_asset, color: Colors.green);
      case 'Scenario':
        return const Icon(Icons.map, color: Colors.orange);
      default:
        return const Icon(Icons.help_outline);
    }
  }

  // Filter button to toggle the selected filter state
  Widget _buildFilterButton(String filterType) {
    return Obx(() {
      // Check if the filter is selected or not
      bool isSelected = selectedFilters.contains(filterType);

      return ElevatedButton(
        onPressed: () {
          // Toggle the filter in the list
          if (isSelected) {
            selectedFilters
                .remove(filterType); // Remove filter if already selected
          } else {
            selectedFilters.add(filterType); // Add filter if not selected
          }
          // Notify the controller to update results
          controller.filterItemsByTypes(selectedFilters);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Colors.blueAccent // Highlight selected filter
              : Colors.grey, // Default color for unselected filter
          foregroundColor: isSelected
              ? Colors.white
              : Colors.black, // Change text color based on selection
        ),
        child: Text(filterType),
      );
    });
  }
}
