## Table of Contents
- [Goal](#goal)
- [Use Cases](#use-cases)
- [Architecture](#architecture)
- [Building the Project](#building-the-project)
- [Summary](#summary)

## Goal

The main goal of the GoTale project is to create a scalable and intuitive system that connects teams of players through shared storytelling and city exploration. The game combines narrative with elements of physical terrain exploration, allowing for unique GPS-based experiences.

## Use Cases

- City games for events.
- Educational tool (e.g., interactive historical stories for students).
- Organizing team-building events or outdoor escape rooms.

## Architecture

The project consists of two main components:

## Mobile Application

Allows teams of players to participate in games based on pre-created gamebooks.

**Technology:** Flutter

**Main Features:**

- User registration and login
- Joining teams or creating new ones
- Experiencing interactive adventures in real-time
- Locating teams on the map using GPS
- Dynamically making decisions in the game and their impact on the story's progression

## Building the Project

### Requirements

- Flutter SDK
- Android Studio or Xcode

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/zesp11/mobile.git
   ```

2. Navigate to the project directory:
   ```bash
   cd mobile
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application on an emulator or physical device:
   ```bash
   flutter run
   ```

## Summary

The GoTale project offers a unique combination of creative storytelling, city exploration, and team collaboration. The mobile application, Gamebook Explorer, provides players with dynamic field experiences. To create your own interactive adventure books, visit our [frontend repository](https://github.com/zesp11/frontend).
