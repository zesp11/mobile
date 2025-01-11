import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/routes/app_routes.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      routerDelegate: Get.rootDelegate,
      builder: (context, delegate, currentRoute) {
        return Scaffold(
          body: GetRouterOutlet(
            // This is where the route content is rendered
            initialRoute: AppRoutes.home,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex(currentRoute?.uri.toString() ?? ''),
            onTap: (index) {
              switch (index) {
                case 0:
                  delegate
                      .toNamed(AppRoutes.home); // Navigating to the home route
                  break;
                case 1:
                  delegate
                      .toNamed(AppRoutes.game); // Navigating to the game route
                  break;
                case 2:
                  delegate.toNamed(
                      AppRoutes.search); // Navigating to the search route
                  break;
                case 3:
                  delegate.toNamed(
                      AppRoutes.profile); // Navigating to the profile route
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.blue,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.play_arrow), label: 'Game'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }

  int _currentIndex(String currentRoute) {
    // Implement logic to return the correct index based on the current route
    if (currentRoute == AppRoutes.home) {
      return 0;
    } else if (currentRoute == AppRoutes.game) {
      return 1;
    } else if (currentRoute == AppRoutes.search) {
      return 2;
    } else if (currentRoute == AppRoutes.profile) {
      return 3;
    }
    return 0;
  }
}
