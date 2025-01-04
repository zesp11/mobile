import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/pages/game_play_screen.dart';
import 'package:goadventure/app/pages/game_selection_screen.dart';
import 'package:goadventure/app/pages/scenario_screen.dart';

class GameRootLayout extends StatefulWidget {
  @override
  _GameRootLayoutState createState() => _GameRootLayoutState();
}

enum GameState {
  selection,
  playing,
  viewing,
}

class _GameRootLayoutState extends State<GameRootLayout> {
  // Track the current state of the game
  GameState _currentState = GameState.selection;

  // Function to handle game selection
  void selectGamebook() {
    setState(() {
      _currentState = GameState.playing;
    });
  }

  // Function to handle viewing mode
  void viewScenario() {
    setState(() {
      _currentState = GameState.viewing;
    });
  }

  // Function to go back to the game selection screen
  void returnToGameSelection() {
    setState(() {
      _currentState = GameState.selection;
    });
  }

  // Function to go back to the game playing screen
  void returnToGamePlaying() {
    setState(() {
      _currentState = GameState.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentState == GameState.selection
          ? GameSelectionScreen(
              onGameSelected: selectGamebook,
              onScenarioSelected: viewScenario,
            )
          : _currentState == GameState.playing
              ? GamePlayScreen(
                  onReturnToSelection: returnToGameSelection,
                )
              : ScenarioScreen(),
    );
  }
}
