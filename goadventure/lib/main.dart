import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/screens/game_page.dart';
import 'package:goadventure/app/screens/home_screen.dart';
import 'package:goadventure/app/screens/profile_screen.dart';
import 'package:goadventure/app/screens/search_page.dart';
import 'package:goadventure/app/services/api_service.dart';

void main() {
  // Register ApiService globally in the main function
  Get.put(ApiService());

  runApp(const GoAdventure());
}

class GoAdventure extends StatelessWidget {
  const GoAdventure({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gamebook App',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LayoutController()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/game', page: () => GameScreen()),
        GetPage(name: '/search', page: () => SearchScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
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
