import 'package:goadventure/app/services/api_service/api_service.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // HTTP library

// TODO: improve development service (maybe sqlite?)
class DevelopmentApiService implements ApiService {
  final Map<String, dynamic> gamebookJson = {
    "name": "Forest Adventure",
    "title": "Into the Enchanted Forest",
    "description":
        "Your choices determine the outcome of this magical journey.",
    "startDate": "2024-12-28T00:00:00.000Z",
    "endDate": null,
    "steps": [
      {
        "id": 1,
        "title": "The Clearing",
        "text": "You wake up in a clearing surrounded by trees.",
        "latitude": 45.0,
        "longitude": -93.0,
        "decisions": [
          {"text": "Follow the path ahead.", "nextStepId": 2},
          {"text": "Investigate the rustling bushes.", "nextStepId": 3}
        ]
      },
      {
        "id": 2,
        "title": "Deeper into the Forest",
        "text": "You venture deeper into the forest, hearing strange sounds.",
        "latitude": 45.01,
        "longitude": -93.01,
        "decisions": [
          {"text": "Return to the clearing.", "nextStepId": 1},
          {"text": "Keep going deeper.", "nextStepId": 4}
        ]
      },
      {
        "id": 3,
        "title": "Rustling Bushes",
        "text": "You find a small rabbit darting out of the bushes.",
        "latitude": 45.02,
        "longitude": -93.02,
        "decisions": [
          {"text": "Chase the rabbit.", "nextStepId": 4},
          {"text": "Ignore the rabbit and follow the path.", "nextStepId": 2}
        ]
      },
      {
        "id": 4,
        "title": "Mysterious Cave",
        "text":
            "You discover a mysterious cave with a faint glow coming from inside.",
        "latitude": 45.03,
        "longitude": -93.03,
        "decisions": [
          {"text": "Enter the cave.", "nextStepId": 5},
          {"text": "Head back to the clearing.", "nextStepId": 1}
        ]
      },
      {
        "id": 5,
        "title": "The Treasure Room",
        "text": "Inside the cave, you find a hidden treasure chest.",
        "latitude": 45.04,
        "longitude": -93.04,
        "decisions": []
      }
    ]
  };

  @override
  // TODO: implement baseUrl
  String get baseUrl => throw UnimplementedError();

  @override
  Future<String> getDecisionStatus(String gameId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Mock decision status
    return "Waiting for response";
  }

  @override
  Future<Map<String, dynamic>> getGameDetails(String gameId) async {
    await Future.delayed(Duration(seconds: 1));

    // Here, you could extract data specific to a gameId if needed
    return {
      "title": gamebookJson["title"],
      "description": gamebookJson["description"],
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

  Future<Map<String, dynamic>> getData(String url) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode the response JSON
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Handle non-200 responses
        throw Exception(
            'Failed to load data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any network or decoding errors
      throw Exception('Error fetching data: $e');
    }
  }

  // Helper function to retrieve the current gamebook's steps
  Future<List<Map<String, dynamic>>> getGameSteps() async {
    await Future.delayed(Duration(seconds: 1));
    return gamebookJson['steps'];
  }

  // Helper function to get a specific step by its ID
  Future<Map<String, dynamic>> getStepById(int stepId) async {
    await Future.delayed(Duration(seconds: 1));
    final steps = gamebookJson['steps'];
    return steps.firstWhere((step) => step['id'] == stepId, orElse: () => {});
  }

  Future<Map<String, dynamic>> getGameBookWithId(int gamebookId) async {
    await Future.delayed(Duration(seconds: 1));
    return gamebookJson;
  }
}
