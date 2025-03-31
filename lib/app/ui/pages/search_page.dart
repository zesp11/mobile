import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:gotale/app/controllers/search_controller.dart" as goTaleSearch;
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/ui/pages/error_screen.dart';

class SearchScreen extends GetView<goTaleSearch.SearchController> {
  final RxList<String> selectedFilters = RxList<String>([]);

  @override
  Widget build(BuildContext context) {
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

class SearchBar extends StatefulWidget {
  final goTaleSearch.SearchController controller;

  SearchBar({required this.controller});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController =
        TextEditingController(text: widget.controller.query.value);
    // Update text controller when query changes
    widget.controller.query.listen((value) {
      if (_textController.text != value) {
        _textController.text = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textController,
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
        onChanged: widget.controller.updateQuery,
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
            // controller.filterItemsByTypes(selectedFilters);
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
          (users) {
            if (users == null || users.isEmpty) {
              return Center(
                child: Text(
                  'no_results_found'.tr,
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          theme.colorScheme.secondary.withOpacity(0.1),
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? Icon(
                              Icons.person,
                              color: theme.colorScheme.secondary,
                            )
                          : null,
                    ),
                    title: Text(
                      user.login,
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      user.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.tertiary,
                    ),
                    onTap: () => _handleUserTap(user),
                  ),
                );
              },
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

  void _handleUserTap(User user) {
    Get.toNamed('/profile/${user.id}');
  }
}
