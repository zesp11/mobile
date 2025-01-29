import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:goadventure/app/controllers/search_controller.dart"
    as goAdventureSearch;
import 'package:goadventure/app/ui/pages/error_screen.dart';

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
          SearchBar(controller: controller),

          const SizedBox(height: 8),

          // Filter Buttons Section
          FilterButtons(
              selectedFilters: selectedFilters, controller: controller),

          const SizedBox(height: 8),

          // Results Section
          Expanded(child: SearchResults(controller: controller)),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final goAdventureSearch.SearchController controller;

  SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          controller.updateQuery(value); // Update the query
        },
      ),
    );
  }
}

class FilterButtons extends StatelessWidget {
  final RxList<String> selectedFilters;
  final goAdventureSearch.SearchController controller;

  FilterButtons({required this.selectedFilters, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildFilterButton("user".tr),
          const SizedBox(width: 8), // Add spacing between buttons
          _buildFilterButton("game".tr),
          const SizedBox(width: 8), // Add spacing between buttons
          _buildFilterButton("scenario".tr),
        ],
      ),
    );
  }

  // Filter button to toggle the selected filter state
  Widget _buildFilterButton(String filterType) {
    return Obx(() {
      // Check if the filter is selected or not
      bool isSelected = selectedFilters.contains(filterType);

      return Expanded(
        child: ElevatedButton(
          onPressed: () {
            // Only toggle filter if it's not visually "disabled"
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
                : Colors.white60, // Light gray for unselected filter
            foregroundColor: isSelected
                ? Colors.white
                : Colors.grey.shade600, // Darker text for "disabled" appearance
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(
              color: isSelected
                  ? Colors.blueAccent
                  : Colors.grey.shade400, // Border color
            ),
          ),
          child: Text(
            filterType,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal, // Regular font weight
            ),
          ),
        ),
      );
    });
  }
}

class SearchResults extends StatelessWidget {
  final goAdventureSearch.SearchController controller;

  SearchResults({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        controller.obx(
          (state) {
            // If no results found
            if (state == null || state.isEmpty) {
              return Center(
                child: Text(
                  'no_results_found'.tr,
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
                          if (item['type'] == 'user') {
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
          },
          onLoading: const Center(
            child: CircularProgressIndicator(), // Show loading spinner
          ),
          onError: (error) => ErrorScreen(
              onRetry: () {
                controller.searchItems(controller.query.value);
              },
              error: error),
        ),
      ],
    );
  }

  // Helper function to return an icon based on type
  Icon _getIconForType(String type) {
    switch (type) {
      case 'user':
        return const Icon(Icons.person, color: Colors.blue);
      case 'game':
        return const Icon(Icons.videogame_asset, color: Colors.green);
      case 'scenario':
        return const Icon(Icons.map, color: Colors.orange);
      default:
        return const Icon(Icons.help_outline);
    }
  }
}
