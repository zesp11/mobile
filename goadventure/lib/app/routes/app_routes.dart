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
  static const home = '/home';
  static const gameSelection = '/game-selection';
  static const gameRoot = '/game';
  static const search = '/search';
  static const profile = '/profile';
  static const scenario = '/scenario';
  static const scenarioDynamic = '$scenario/:id';

  static final routes = [
    GetPage(name: '/', page: () => LayoutController()),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: gameSelection,
      binding: GameBinding(),
      page: () => GameSelectionScreen(
        onGameSelected: () {
          // Handle game selected logic here
        },
        onScenarioSelected: () {
          // handle selection logic here
        },
      ),
    ),
    GetPage(
      name: gameRoot,
      page: () => GamePlayScreen(onReturnToSelection: () {}),
    ),
    GetPage(
      name: gameRoot,
      page: () => GameRootLayout(),
    ),
    GetPage(
      name: search,
      page: () => SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
