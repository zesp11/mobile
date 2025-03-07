import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:gotale/app/controllers/search_controller.dart" as goTaleSearch;
import 'package:gotale/app/ui/pages/error_screen.dart';

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

class SearchScreen extends GetView<goTaleSearch.SearchController> {
  // Track selected filters
  final RxList<String> selectedFilters = RxList<String>([]);

  @override
  Widget build(BuildContext context) {
    // Initially load all available items
    controller.searchItems('');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchBar(controller: controller),
            const SizedBox(height: 12),
            FilterButtons(
                selectedFilters: selectedFilters, controller: controller),
            const SizedBox(height: 16),
            Expanded(child: SearchResults(controller: controller)),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final goTaleSearch.SearchController controller;

  SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          hintStyle: theme.textTheme.bodyMedium,
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.tertiary),
          filled: true,
          fillColor: theme.cardTheme.color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: theme.colorScheme.tertiary.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: theme.colorScheme.tertiary.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.secondary),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: theme.textTheme.bodyLarge,
        onChanged: controller.updateQuery,
      ),
    );
  }
}

class FilterButtons extends StatelessWidget {
  final RxList<String> selectedFilters;
  final goTaleSearch.SearchController controller;

  FilterButtons({required this.selectedFilters, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterButton("user".tr, context),
          const SizedBox(width: 12),
          _buildFilterButton("scenario".tr, context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filterType, BuildContext context) {
    final theme = Theme.of(context);

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
                ? theme.colorScheme.secondary
                : theme.cardTheme.color,
            foregroundColor: isSelected
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.onBackground,
            elevation: isSelected ? 2 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.tertiary.withOpacity(0.2),
              ),
            ),
          ),
          child: Text(
            filterType,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.onBackground,
            ),
          ),
        ),
      );
    });
  }
}

class SearchResults extends StatelessWidget {
  final goTaleSearch.SearchController controller;

  SearchResults({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        controller.obx(
          (state) {
            if (state == null || state.isEmpty) {
              return Center(
                child: Text(
                  'no_results_found'.tr,
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }

            Map<String, List<Map<String, String>>> groupedItems = {};
            for (var item in state) {
              final type = item['type']!;
              groupedItems.putIfAbsent(type, () => []).add(item);
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: groupedItems.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        entry.key.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...entry.value.map((item) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.secondary.withOpacity(0.1),
                            child: Icon(
                              _getIconForType(item['type']!),
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          title: Text(
                            item['name']!,
                            style: theme.textTheme.titleMedium,
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.tertiary,
                          ),
                          onTap: () => _handleItemTap(item),
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            );
          },
          onLoading: Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.secondary,
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

  IconData _getIconForType(String type) {
    return _typeIcons[type] ?? Icons.help_outline;
  }

  final _typeIcons = {
    'user': Icons.person,
    'scenario': Icons.map,
  };

  void _handleItemTap(Map<String, String> item) {
    if (item['type'] == 'user') {
      Get.toNamed('/profile/${item["id"]}');
    } else if (item['type'] == 'scenario') {
      Get.toNamed('/scenario/${item["id"]}');
    }
  }
}
