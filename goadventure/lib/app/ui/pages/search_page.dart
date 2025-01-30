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
          hintStyle: TextStyle(color: Color(0xFF9C8B73)), // Secondary
          prefixIcon: Icon(Icons.search, color: Color(0xFF9C8B73)), // Secondary
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF9C8B73).withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFFA802F)), // Accent
          ),
        ),
        onChanged: controller.updateQuery,
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

  Widget _buildFilterButton(String filterType) {
    return Obx(() {
      bool isSelected = selectedFilters.contains(filterType);
      return Expanded(
        child: ElevatedButton(
          onPressed: () {
            if (isSelected) {
              selectedFilters.remove(filterType);
            } else {
              selectedFilters.add(filterType);
            }
            controller.filterItemsByTypes(selectedFilters);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? Color(0xFFFA802F).withOpacity(0.9) // Accent
                : Color(0xFFF3E8CA).withOpacity(0.5), // Background
            foregroundColor: isSelected
                ? Color(0xFFF3E8CA) // Background
                : Color(0xFF322505), // Foreground
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected
                    ? Color(0xFFFA802F) // Accent
                    : Color(0xFF9C8B73).withOpacity(0.3), // Secondary
              ),
            ),
          ),
          child: Text(
            filterType,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
            if (state == null || state.isEmpty) {
              return Center(
                child: Text(
                  'no_results_found'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9C8B73),
                  ),
                ),
              );
            }

            // Add grouping logic here
            Map<String, List<Map<String, String>>> groupedItems = {};
            for (var item in state) {
              final type = item['type']!;
              groupedItems.putIfAbsent(type, () => []).add(item);
            }

            return ListView(
              children: groupedItems.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFA802F),
                        ),
                      ),
                    ),
                    ...entry.value.map((item) {
                      return ListTile(
                        leading: _getIconForType(item['type']!),
                        title: Text(
                          item['name']!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF322505),
                          ),
                        ),
                        subtitle: Text(
                          item['type']!,
                          style: TextStyle(
                            color: Color(0xFF9C8B73),
                          ),
                        ),
                        onTap: () => _handleItemTap(item),
                      );
                    }),
                  ],
                );
              }).toList(),
            );
          },
          onLoading: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFA802F),
            ),
          ),
          onError: (error) => ErrorScreen(
            onRetry: () => controller.searchItems(controller.query.value),
            error: error,
          ),
        ),
      ],
    );
  }

  Icon _getIconForType(String type) {
    return Icon(
      _typeIcons[type] ?? Icons.help_outline,
      color: Color(0xFFFA802F), // Accent color for all icons
    );
  }

  final _typeIcons = {
    'user': Icons.person,
    'game': Icons.videogame_asset,
    'scenario': Icons.map,
  };

  void _handleItemTap(Map<String, String> item) {
    if (item['type'] == 'user') {
      Get.toNamed('/profile/${item["id"]}');
    } else if (item['type'] == 'scenario') {
      Get.toNamed('/scenario/${item["id"]}');
    } else {
      Get.snackbar(
        item['name']!,
        'Selected: ${item['name']}',
        backgroundColor: Color(0xFFF3E8CA), // Background
        colorText: Color(0xFF322505), // Foreground
      );
    }
  }
}
