import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/routes/app_routes.dart';

class GameRootLayout extends StatelessWidget {
  const GameRootLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      routerDelegate: Get.rootDelegate, // Use Get's root delegate
      builder: (context, delegate, currentRoute) {
        return Scaffold(
          body: GetRouterOutlet(
            initialRoute:
                // TODO: read if there should be /game or /game/select
                AppRoutes.gameSelection, // Default to the game selection screen
          ),
        );
      },
    );
  }
}
