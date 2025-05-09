// Define all your routes in a central location
import 'package:get/get.dart';
import 'package:gotale/app/bindings/home_binding.dart';
import 'package:gotale/app/bindings/profile_binding.dart';
import 'package:gotale/app/bindings/search_binding.dart';
import 'package:gotale/app/ui/pages/home_screen.dart';
import 'package:gotale/app/ui/pages/login_screen.dart';
import 'package:gotale/app/ui/pages/profile_edit_screen.dart';
import 'package:gotale/app/ui/layouts/root_layout.dart';
import 'package:gotale/app/ui/pages/game_play_screen.dart';
import 'package:gotale/app/ui/layouts/game_root_layout.dart';
import 'package:gotale/app/ui/pages/game_selection_screen.dart';
import 'package:gotale/app/ui/pages/profile_screen.dart';
import 'package:gotale/app/ui/pages/register_screen.dart';
import 'package:gotale/app/ui/pages/scenario_screen.dart';
import 'package:gotale/app/ui/pages/search_page.dart';
import 'package:gotale/app/ui/pages/settings_screen.dart';
import 'package:gotale/app/ui/pages/user_profile_screen.dart';
import 'package:gotale/app/ui/pages/welcome_screen.dart';

class AppRoutes {
  // Define route names as static constants for easier reference
  //**************************************************************
  // main navigation tabs
  static const home = '/home';
  static const game = '/game';
  static const search = '/search';
  static const profile = '/profile';
  static const settings = '/settings';
  static const welcome = "/welcome";

  // nested game routes
  static const gameSelection = '$game/select';
  static const gameDetail = '$game/:id';
  static const gameDecision = '$game/:id/decision';
  static const gameHistory = '$game/:id/decision';
  static const gameMap = '$game/:id/map';

  // Scenario route (distinct but within game tab context)
  static const scenario = '/scenario';
  static const scenarioDetail = '$scenario/:id';

  static const login = '/login';
  static const register = '/register';
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
        GetPage(
          name: game,
          page: () => GameRootLayout(),
          children: [
            GetPage(
              name: "/select",
              page: () => GameSelectionScreen(),
            ),
            GetPage(
              name: "/:id",
              page: () => GamePlayScreen(),
            ),

            // GetPage(name: gameDecision, page: () => GameDecisionScreen()),
            // GetPage(name: gameHistory, page: () => GameHistoryScreen()),
            // GetPage(name: gameMap, page: () => GameMapScreen()),
          ],
        ),
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
          children: [
            // static routes first
            GetPage(name: '/edit', page: () => ProfileEditScreen()),
            // to prevent /edit being interpreted as dynamic segment
            GetPage(name: '/:id', page: () => UserProfileScreen()),
          ],
        ),

        // Settings tab
        GetPage(
          name: settings,
          page: () => SettingsScreen(),
        ),

        // Auth routes
        GetPage(
          name: login,
          page: () => LoginScreen(),
        ),
        GetPage(
          name: register,
          page: () => RegisterScreen(),
        ),
      ],
    ),
    // Add welcome screen as separate page
    GetPage(
      name: welcome,
      page: () => OnboardingScreen(),
    ),
  ];
}
