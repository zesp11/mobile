import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/pages/game_play_screen.dart';
import 'package:goadventure/app/pages/game_selection_screen.dart';

class GameRootLayout extends StatefulWidget {
  @override
  _GameRootLayoutState createState() => _GameRootLayoutState();
}

class _GameRootLayoutState extends State<GameRootLayout> {
  // Flag to indicate if a gamebook has been selected
  bool isGameSelected = false;

  // Function to handle game selection
  void selectGamebook() {
    setState(() {
      isGameSelected = true;
    });
  }

  // Function to go back to the game selection screen
  void returnToGameSelection() {
    setState(() {
      isGameSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isGameSelected
          ? GamePlayScreen(onReturnToSelection: returnToGameSelection)
          : GameSelectionScreen(onGameSelected: selectGamebook),
    );
  }
}
