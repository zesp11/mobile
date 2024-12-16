import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // TODO: create model to fetch info from db
  final List<Map<String, String>> _allItems = [
    {'name': 'Alice', 'type': 'User'},
    {'name': 'Bob', 'type': 'User'},
    {'name': 'Chess Master', 'type': 'Game'},
    {'name': 'Zombie Escape', 'type': 'Scenario'},
    {'name': 'Charlie', 'type': 'User'},
    {'name': 'Space Adventure', 'type': 'Game'},
    {'name': 'Desert Survival', 'type': 'Scenario'},
  ];
  String _query = "";

  List<Map<String, String>> get _filteredItems {
    return _allItems
        .where((item) =>
            item['name']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

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
                setState(() {
                  _query = value; // Update query
                });
              },
            ),
          ),
          const SizedBox(height: 8),

          // Results Section
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
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
}
