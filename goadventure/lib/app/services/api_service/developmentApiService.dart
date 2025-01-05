import 'package:goadventure/app/services/api_service/api_service.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // HTTP library

// TODO: improve development service (maybe sqlite?)
class DevelopmentApiService implements ApiService {
  final int id = 0; // default gamebook index
  final List<Map<String, dynamic>> gamebooksJson = [
    {
      "id": 0,
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
    },
    {
      "id": 1,
      "name": "The Lost City",
      "title": "Journey to the Forgotten Ruins",
      "description":
          "Embark on a dangerous journey to discover an ancient city.",
      "startDate": "2024-12-30T00:00:00.000Z",
      "endDate": null,
      "steps": [
        {
          "id": 1,
          "title": "The Village Square",
          "text": "You start your journey from a small village square.",
          "latitude": 47.0,
          "longitude": -91.0,
          "decisions": [
            {"text": "Talk to the villagers.", "nextStepId": 2},
            {"text": "Head straight to the ruins.", "nextStepId": 3}
          ]
        },
        {
          "id": 2,
          "title": "The Wise Elder",
          "text": "The village elder warns you of the dangers ahead.",
          "latitude": 47.1,
          "longitude": -91.1,
          "decisions": [
            {"text": "Thank the elder and leave.", "nextStepId": 3},
            {"text": "Ask the elder for more advice.", "nextStepId": 4}
          ]
        },
        {
          "id": 3,
          "title": "The Forgotten Ruins",
          "text":
              "You arrive at the ruins, but a sense of dread fills the air.",
          "latitude": 47.2,
          "longitude": -91.2,
          "decisions": [
            {"text": "Explore the ruins cautiously.", "nextStepId": 5},
            {"text": "Look for a way to bypass the ruins.", "nextStepId": 6}
          ]
        },
        {
          "id": 4,
          "title": "The Elders' Warning",
          "text": "The elder speaks of a hidden temple deep within the ruins.",
          "latitude": 47.3,
          "longitude": -91.3,
          "decisions": [
            {"text": "Search for the hidden temple.", "nextStepId": 7},
            {"text": "Ignore the warning and proceed.", "nextStepId": 5}
          ]
        },
        {
          "id": 5,
          "title": "The Hidden Temple",
          "text": "You find the ancient temple, guarded by mysterious statues.",
          "latitude": 47.4,
          "longitude": -91.4,
          "decisions": [
            {"text": "Enter the temple.", "nextStepId": 8},
            {"text": "Turn back and leave the ruins.", "nextStepId": 9}
          ]
        },
        {
          "id": 6,
          "title": "The Path Through the Jungle",
          "text": "You find a narrow path leading through thick jungle.",
          "latitude": 47.5,
          "longitude": -91.5,
          "decisions": [
            {"text": "Continue through the jungle.", "nextStepId": 10},
            {"text": "Head back to the village.", "nextStepId": 1}
          ]
        }
      ]
    },
    {
      "id": 2,
      "name": "Pirates of the Lost Sea",
      "title": "Quest for the Treasure of the Black Flag",
      "description":
          "A pirate adventure filled with treasure hunts and perilous decisions.",
      "startDate": "2024-12-25T00:00:00.000Z",
      "endDate": null,
      "steps": [
        {
          "id": 1,
          "title": "The Pirate Ship",
          "text": "You board the notorious pirate ship, The Black Flag.",
          "latitude": 19.0,
          "longitude": -73.0,
          "decisions": [
            {
              "text": "Join the crew in searching for treasure.",
              "nextStepId": 2
            },
            {"text": "Try to escape the ship.", "nextStepId": 3}
          ]
        },
        {
          "id": 2,
          "title": "The Treasure Map",
          "text":
              "The captain shows you a treasure map with hidden coordinates.",
          "latitude": 19.1,
          "longitude": -73.1,
          "decisions": [
            {"text": "Follow the map's path.", "nextStepId": 4},
            {"text": "Challenge the captain for the map.", "nextStepId": 5}
          ]
        },
        {
          "id": 3,
          "title": "Escape from the Ship",
          "text": "You try to flee but are caught by the crew.",
          "latitude": 19.2,
          "longitude": -73.2,
          "decisions": [
            {"text": "Agree to join the crew.", "nextStepId": 2},
            {"text": "Fight back and try to escape.", "nextStepId": 6}
          ]
        },
        {
          "id": 4,
          "title": "The Island of Secrets",
          "text": "The map leads you to an uncharted island with hidden caves.",
          "latitude": 19.3,
          "longitude": -73.3,
          "decisions": [
            {"text": "Search the caves.", "nextStepId": 7},
            {"text": "Camp on the beach and wait.", "nextStepId": 8}
          ]
        },
        {
          "id": 5,
          "title": "Pirate Mutiny",
          "text": "The crew mutinies against the captain, and chaos ensues.",
          "latitude": 19.4,
          "longitude": -73.4,
          "decisions": [
            {"text": "Take the captain's place.", "nextStepId": 9},
            {
              "text": "Escape the mutiny and search for treasure.",
              "nextStepId": 10
            }
          ]
        },
        {
          "id": 6,
          "title": "Walking the Plank",
          "text": "The crew throws you overboard. You are now lost at sea.",
          "latitude": 19.5,
          "longitude": -73.5,
          "decisions": [
            {"text": "Swim towards the nearest island.", "nextStepId": 4},
            {"text": "Attempt to catch a passing ship.", "nextStepId": 11}
          ]
        }
      ]
    }
  ];

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
      "title": gamebooksJson[id]["title"],
      "description": gamebooksJson[id]["description"],
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

    // TODO: keep that data inside one place (maybe sqlite db?)
    List<Map<String, String>> allItems = [
      {
        'name': 'Alice',
        'type': 'User',
        "id": "1",
      },
      {
        'name': 'Bob',
        'type': 'User',
        "id": "2",
      },
      {'name': 'Chess Master', 'type': 'Game'},
      {'name': 'Zombie Escape', 'type': 'Scenario'},
      {
        'name': 'Charlie',
        'type': 'User',
        "id": "3",
      },
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
    return gamebooksJson[id]['steps'];
  }

  // Helper function to get a specific step by its ID
  Future<Map<String, dynamic>> getStepById(int stepId) async {
    await Future.delayed(Duration(seconds: 1));
    final steps = gamebooksJson[id]['steps'];
    return steps.firstWhere((step) => step['id'] == stepId, orElse: () => {});
  }

  Future<Map<String, dynamic>> getGameBookWithId(int id) async {
    print("[DEV_DEBUG] Fetching gamebook with id=$id");
    await Future.delayed(Duration(seconds: 1));
    return gamebooksJson[id];
  }

  Future<List<Map<String, dynamic>>> getAvailableGamebooks() async {
    await Future.delayed(Duration(seconds: 1));
    return gamebooksJson;
  }
}
