// Define all your routes in a central location
import 'package:get/get.dart';
import 'package:goadventure/app/bindings/game_binding.dart';
import 'package:goadventure/app/bindings/home_binding.dart';
import 'package:goadventure/app/bindings/profile_binding.dart';
import 'package:goadventure/app/bindings/search_binding.dart';
import 'package:goadventure/app/controllers/layout_controller.dart';
import 'package:goadventure/app/pages/game_play_screen.dart';
import 'package:goadventure/app/pages/game_root_layout.dart';
import 'package:goadventure/app/pages/game_selection_screen.dart';
import 'package:goadventure/app/pages/home_screen.dart';
import 'package:goadventure/app/pages/profile_screen.dart';
import 'package:goadventure/app/pages/scenario_screen.dart';
import 'package:goadventure/app/pages/search_page.dart';
import 'package:goadventure/main.dart';

class AppRoutes {
  // Define route names as static constants for easier reference
  //**************************************************************
  // main navigation tabs
  static const home = '/home';
  static const game = '/game';
  static const search = '/search';
  static const profile = '/profile';

  // nested game routes
  static const gameSelection = '$game/select';
  static const gameDetail = '$game/:id';
  static const gameDecision = '$game/:id/decision';
  static const gameHistory = '$game/:id/decision';
  static const gameMap = '$game/:id/map';

  // Scenario route (distinct but within game tab context)
  static const scenario = '/scenario';
  static const scenarioDetail = '$scenario/:id';
  static const scenarioDynamic = '$scenario/:id';
  //**************************************************************

  /*
  TODO: middleware to redirect
  middlewares: [
    AuthGuard(redirectTo: '/home'),
  ],
  */
  static final routes = [
    GetPage(
      name: '/',
      page: () => const RootLayout(),
      children: [
        GetPage(
          name: home,
          page: () => HomeScreen(),
          binding: HomeBinding(),
        ),
        GetPage(name: game, page: () => GameRootLayout(), children: [
          GetPage(
            name: "/select",
            page: () => GameSelectionScreen(
              onGameSelected: () {},
              onScenarioSelected: () {},
            ),
          ),
          GetPage(
            name: "/:id",
            page: () => GamePlayScreen(
              onReturnToSelection: () {},
            ),
          ),

          // GetPage(name: gameDecision, page: () => GameDecisionScreen()),
          // GetPage(name: gameHistory, page: () => GameHistoryScreen()),
          // GetPage(name: gameMap, page: () => GameMapScreen()),
        ]),
        // Distinct scenario route (but still within game tab bottom app bar context)
        GetPage(
          name: scenarioDetail,
          page: () => ScenarioScreen(),
        ),

        // Search tab
        GetPage(
          name: search,
          page: () => SearchScreen(),
          binding: SearchBinding(),
        ),

        // Profile tab
        GetPage(
          name: profile,
          page: () => ProfileScreen(),
          binding: ProfileBinding(),
        ),
      ],
    ),
  ];
}
