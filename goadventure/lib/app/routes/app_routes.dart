// Define all your routes in a central location
import 'package:get/get.dart';
import 'package:goadventure/app/bindings/game_binding.dart';
import 'package:goadventure/app/bindings/home_binding.dart';
import 'package:goadventure/app/bindings/profile_binding.dart';
import 'package:goadventure/app/bindings/search_binding.dart';
import 'package:goadventure/app/pages/game_play_screen.dart';
import 'package:goadventure/app/pages/game_root_layout.dart';
import 'package:goadventure/app/pages/game_selection_screen.dart';
import 'package:goadventure/app/pages/home_screen.dart';
import 'package:goadventure/app/pages/profile_screen.dart';
import 'package:goadventure/app/pages/search_page.dart';

class AppRoutes {
  // Define route names as static constants for easier reference
  static const home = '/home';
  static const gameSelection = '/game-selection';
  static const game = '/game';
  static const gameRoot = '/game-root';
  static const search = '/search';
  static const profile = '/profile';

  static final routes = [
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
      ),
    ),
    GetPage(
      name: game,
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
