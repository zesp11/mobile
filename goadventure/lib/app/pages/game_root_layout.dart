import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/pages/game_play_screen.dart';
import 'package:goadventure/app/pages/game_selection_screen.dart';
import 'package:goadventure/app/routes/app_routes.dart';

class GameRootLayout extends StatelessWidget {
  const GameRootLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      routerDelegate: Get.rootDelegate, // Use Get's root delegate
      builder: (context, delegate, currentRoute) {
        return Scaffold(
          body: GetRouterOutlet(
            initialRoute:
                AppRoutes.gameSelection, // Default to the game selection screen
          ),
        );
      },
    );
  }
}
