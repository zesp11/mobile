import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:goadventure/app/controllers/search_controller.dart"
    as customSearch;

// TODO: screen for profile editing
// TODO: screen for viewing other user profile
// TODO: screen for detailed game listing
// TODO: filters for search

// BUG: after switching screen the search query is cleared but the filtered items remain the same
class SearchScreen extends StatelessWidget {
  // Get the controller instance
  final customSearch.SearchController controller =
      Get.put(customSearch.SearchController(searchService: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        centerTitle: true,
      ),
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
                // TODO: add debouncing to prevent network overhead
                controller.updateQuery(value);
              },
            ),
          ),
          const SizedBox(height: 8),

          // Results Section
          Expanded(
            child: Obx(() {
              // Get filtered items reactively
              final filteredItems = controller.filteredItems.value;

              return filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          leading: _getIconForType(item['type']!),
                          title: Text(
                            item['name']!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(item['type']!),
                          onTap: () {
                            // Action when an item is tapped
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Selected: ${item['name']}'),
                              ),
                            );
                          },
                        );
                      },
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
}
