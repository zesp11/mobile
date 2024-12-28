import 'package:goadventure/app/services/api_service/api_service.dart';

class DevelopmentApiService implements ApiService {
  @override
  // TODO: implement baseUrl
  String get baseUrl => throw UnimplementedError();

  @override
  getData(String url) {
    // TODO: implement getData
    throw UnimplementedError();
  }

  @override
  Future<String> getDecisionStatus(String gameId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Mock decision status
    return "Waiting for response";
  }

  @override
  Future<Map<String, dynamic>> getGameDetails(String gameId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Mock game details
    return {
      "title": "Dragon's Quest",
      "description": "A thrilling adventure to save the kingdom from a dragon.",
      "progress": "Chapter 2 - The Lava Caves"
    };
  }

  @override
  Future<List> getNearbyGamebooks(Map<String, double> location) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Mock nearby games with steps and decisions to match the Gamebook model
    return [
      {
        "title": "Dragon's Quest",
        "name": "Dragon's Quest",
        "startDate": "2024-12-28T00:00:00Z",
        "endDate": "2024-12-31T00:00:00Z",
        "steps": [
          {
            "name": "Start Adventure",
            "nextItem": "Dragon's Cave",
            "decisions": [
              {"text": "Enter the cave", "action": "start"},
              {"text": "Turn back", "action": "exit"}
            ]
          }
        ]
      },
      {
        "title": "Zombie Escape",
        "name": "Zombie Escape",
        "startDate": "2024-12-20T00:00:00Z",
        "endDate": null,
        "steps": [
          {
            "name": "Zombie Attack",
            "nextItem": "Safehouse",
            "decisions": [
              {"text": "Fight zombies", "action": "fight"},
              {"text": "Run away", "action": "run"}
            ]
          }
        ]
      },
      {
        "title": "Mystery Mansion",
        "name": "Mystery Mansion",
        "startDate": "2024-12-25T00:00:00Z",
        "endDate": null,
        "steps": [
          {
            "name": "First Clue",
            "nextItem": "Library",
            "decisions": [
              {"text": "Investigate", "action": "investigate"},
              {"text": "Leave", "action": "leave"}
            ]
          }
        ]
      }
    ];
  }

  @override
  Future<List> getNewGamebooks() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Mock data
    return [
      {
        "title": "Space Odyssey",
        "description": "Explore the galaxy in this sci-fi adventure."
      },
      {
        "title": "Mystery Mansion",
        "description": "Solve puzzles in a haunted mansion."
      },
      {
        "title": "Alien Invasion",
        "description": "Defend Earth from extraterrestrial forces."
      }
    ];
  }

  @override
  Future<List> getResumeGames() async {
    // Simulate network delay for development
    await Future.delayed(Duration(seconds: 1));

    // Mock data to simulate the response with gamebook structure
    // Mock data to simulate the response with the Gamebook structure
    return [
      {
        "name": "Wizard's Journey",
        "title": "Wizard's Journey",
        "startDate": "2024-12-15T00:00:00Z",
        "endDate": null,
        "steps": [
          {
            "name": "Wizards' Meeting",
            "nextItem": "The Mystic Forest",
            "decisions": [
              {"text": "Speak to the elder", "action": "talk"},
              {"text": "Leave the meeting", "action": "exit"}
            ]
          }
        ]
      },
      {
        "name": "Dragon's Quest",
        "title": "Dragon's Quest",
        "startDate": "2024-12-20T00:00:00Z",
        "endDate": null,
        "steps": [
          {
            "name": "Dragon Battle",
            "nextItem": "The Lava Caves",
            "decisions": [
              {"text": "Attack the dragon", "action": "fight"},
              {"text": "Wait for a better opportunity", "action": "wait"}
            ]
          }
        ]
      }
    ];
  }

  @override
  Future<Map<String, dynamic>> getUserProfile() async {
    // TODO: (should we in development API?)
    // Simulate a network delay
    await Future.delayed(Duration(milliseconds: 500));

    // Returning mock user profile data
    return {
      "id": "12345",
      "name": "John Doe",
      "email": "johndoe@example.com",
      "avatar": "", // No avatar provided
      "bio": "Just a mock user for development purposes.",
      "gamesPlayed": 50, // Example data
      "gamesFinished": 30, // Example data
      "preferences": {
        "theme": "dark",
        "notifications": true,
      },
    };
  }

  @override
  Future<List> search(String query, String category) async {
    // Example: Search across all items (you could adjust based on category)
    // Simulating a search result from a local mock data
    List<Map<String, String>> allItems = [
      {'name': 'Alice', 'type': 'User'},
      {'name': 'Bob', 'type': 'User'},
      {'name': 'Chess Master', 'type': 'Game'},
      {'name': 'Zombie Escape', 'type': 'Scenario'},
      {'name': 'Charlie', 'type': 'User'},
      {'name': 'Space Adventure', 'type': 'Game'},
      {'name': 'Desert Survival', 'type': 'Scenario'},
    ];

    // Filter based on query and category (you can adjust the filtering logic here)
    return allItems.where((item) {
      bool matchesQuery =
          item['name']!.toLowerCase().contains(query.toLowerCase());
      if (category != 'all') {
        return matchesQuery && item['type'] == category;
      }
      return matchesQuery;
    }).toList();
  }

  @override
  Future<void> submitDecision(String gameId, String decision) async {
    // Simulate a network request for submitting decisions
    await Future.delayed(Duration(seconds: 1));
    print('Decision "$decision" for game $gameId submitted.');
  }

  @override
  Future<void> updateUserProfile(Map<String, dynamic> profile) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}
