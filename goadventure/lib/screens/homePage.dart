import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for nearby games and the last game
    final List<Map<String, String>> nearbyGames = [
      {"title": "Dragon's Quest", "distance": "2 km"},
      {"title": "Zombie Escape", "distance": "5 km"},
      {"title": "Mystery Mansion", "distance": "1.5 km"},
    ];

    final Map<String, String> lastGame = {
      "title": "Wizard's Journey",
      "progress": "Chapter 4 - The Mystic Forest",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Book Home'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Resume Last Game
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              color: Colors.blueAccent,
              child: ListTile(
                leading:
                    const Icon(Icons.play_arrow, size: 40, color: Colors.white),
                title: Text(
                  lastGame['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Continue: ${lastGame['progress']}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  // Action: Resume the last game
                  print("Resuming ${lastGame['title']}");
                },
              ),
            ),
          ),
          const Divider(),
          // Section: Nearby Games
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Nearby Games',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nearbyGames.length,
              itemBuilder: (context, index) {
                final game = nearbyGames[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.location_on,
                        color: Colors.redAccent, size: 30),
                    title: Text(
                      game['title']!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Distance: ${game['distance']}"),
                    onTap: () {
                      // Action: Start or view details of the game
                      print("Starting ${game['title']}");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
