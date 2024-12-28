// Define all your routes in a central location
import 'package:get/get.dart';
import 'package:goadventure/app/bindings/game_binding.dart';
import 'package:goadventure/app/bindings/home_binding.dart';
import 'package:goadventure/app/bindings/profile_binding.dart';
import 'package:goadventure/app/bindings/search_binding.dart';
import 'package:goadventure/app/pages/game_page.dart';
import 'package:goadventure/app/pages/home_screen.dart';
import 'package:goadventure/app/pages/profile_screen.dart';
import 'package:goadventure/app/pages/search_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/home', page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(name: '/game', page: () => GameScreen(), binding: GameBinding()),
    GetPage(
        name: '/search', page: () => SearchScreen(), binding: SearchBinding()),
    GetPage(
        name: '/profile',
        page: () => ProfileScreen(),
        binding: ProfileBinding()),
  ];
}
