import 'package:goadventure/app/models/user.dart';

final int id = 0; // default gamebook index
final List<Map<String, dynamic>> mockGamebooksJson = [
  {
    "id": 0,
    "name": "Forest Adventure",
    "title": "Into the Enchanted Forest",
    "description":
        "Your choices determine the outcome of this magical journey.",
    "startDate": "2024-12-28T00:00:00.000Z",
    "endDate": null,
    "authorId": 1,
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
    "description": "Embark on a dangerous journey to discover an ancient city.",
    "startDate": "2024-12-30T00:00:00.000Z",
    "endDate": null,
    "authorId": 2,
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
        "text": "You arrive at the ruins, but a sense of dread fills the air.",
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
    "authorId": 2,
    "steps": [
      {
        "id": 1,
        "title": "The Pirate Ship",
        "text": "You board the notorious pirate ship, The Black Flag.",
        "latitude": 19.0,
        "longitude": -73.0,
        "decisions": [
          {"text": "Join the crew in searching for treasure.", "nextStepId": 2},
          {"text": "Try to escape the ship.", "nextStepId": 3}
        ]
      },
      {
        "id": 2,
        "title": "The Treasure Map",
        "text": "The captain shows you a treasure map with hidden coordinates.",
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

List<UserProfile> mockUsers = [
  UserProfile(
    id: '1',
    name: 'John Doe',
    email: 'johndoe@example.com',
    avatar: 'https://randomuser.me/api/portraits/men/1.jpg',
    bio: 'A passionate gamer and tech enthusiast.',
    gamesPlayed: 120,
    gamesFinished: 90,
    preferences: {'theme': 'dark', 'notifications': 'enabled'},
  ),
  UserProfile(
    id: '2',
    name: 'Jane Smith',
    email: 'janesmith@example.com',
    avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
    bio: 'Lover of adventure games and puzzle challenges.',
    gamesPlayed: 75,
    gamesFinished: 60,
    preferences: {'theme': 'light', 'notifications': 'disabled'},
  ),
  UserProfile(
    id: '3',
    name: 'Alex Johnson',
    email: 'alexjohnson@example.com',
    avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
    bio: 'Casual gamer with a focus on strategy games.',
    gamesPlayed: 50,
    gamesFinished: 30,
    preferences: {'theme': 'dark', 'notifications': 'enabled'},
  ),
];
