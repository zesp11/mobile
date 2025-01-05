import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:goadventure/app/controllers/search_controller.dart"
    as customSearch;

// TODO: screen for profile editing
// TODO: screen for viewing other user profile
// TODO: screen for detailed game listing
class SearchScreen extends StatelessWidget {
  final customSearch.SearchController controller =
      Get.put(customSearch.SearchController(searchService: Get.find()));

  // Track selected filters
  RxList<String> selectedFilters = RxList<String>([]);

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
                // Update the query in the controller
                controller.updateQuery(value);
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
            child: Obx(() {
              final filteredItems = controller.filteredItems.value;

              // Group by 'type' field in the item (e.g., User, Game, Scenario)
              Map<String, List<Map<String, String>>> groupedItems = {};

              // Group the items based on their type
              for (var item in filteredItems) {
                final type = item['type']!;
                if (!groupedItems.containsKey(type)) {
                  groupedItems[type] = [];
                }

                groupedItems[type]?.add(item);
              }

              // If no results found
              if (filteredItems.isEmpty) {
                return const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              // List all groups
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
                            // Action when an item is tapped
                            // TODO: change hard coded links to those from AppRoutes
                            if (item['type'] == 'User') {
                              Get.toNamed('/profile/${item["id"]}');
                            } else if (item['type'] == 'Scenario') {
                              Get.toNamed('/scenario/${item["id"]}');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected: ${item['name']}'),
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
            }),
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
