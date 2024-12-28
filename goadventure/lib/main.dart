import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/bindings/app_binding.dart';
import 'package:goadventure/app/bindings/home_binding.dart';
import 'package:goadventure/app/bindings/profile_binding.dart';
import 'package:goadventure/app/screens/game_page.dart';
import 'package:goadventure/app/screens/home_screen.dart';
import 'package:goadventure/app/screens/profile_screen.dart';
import 'package:goadventure/app/screens/search_page.dart';

void main() {
  final bool isProduction = const bool.fromEnvironment('dart.vm.product');

  runApp(GoAdventure(isProduction: isProduction));
}

class GoAdventure extends StatelessWidget {
  final bool isProduction;

  const GoAdventure({super.key, required this.isProduction});

  // For production, run with dart --define=dart.vm.product=true.
  // For development, no additional flags are needed (default is false).

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gamebook App',
      initialRoute: '/',
      initialBinding: AppBindings(isProduction: isProduction),
      getPages: [
        GetPage(name: '/', page: () => LayoutController()),
        GetPage(
            name: '/home',
            page: () => HomeScreen(),
            binding: HomeBinding()), // Bindings for HomeScreen
        GetPage(name: '/game', page: () => GameScreen()),
        GetPage(name: '/search', page: () => SearchScreen()),
        GetPage(
            name: '/profile',
            page: () => ProfileScreen(),
            binding: ProfileBinding()), // Bindings for ProfileScreen
      ],
    );
  }
}

class LayoutController extends StatelessWidget {
  const LayoutController({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LayoutControllerLogic>(
      init: LayoutControllerLogic(),
      builder: (controller) {
        return Scaffold(
          body: controller.getSelectedScreen(), // Render the selected screen
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_arrow),
                label: "Game",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
            currentIndex: controller.selectedIndex,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.blue,
            onTap: controller.onItemTapped,
          ),
        );
      },
    );
  }
}

class LayoutControllerLogic extends GetxController {
  int selectedIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    HomeScreen(),
    GameScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  // Update the selected index
  void onItemTapped(int index) {
    selectedIndex = index;
    update(); // Notify the UI to rebuild
  }

  // Get the current screen based on the selected index
  Widget getSelectedScreen() {
    return _screens[selectedIndex];
  }
}
