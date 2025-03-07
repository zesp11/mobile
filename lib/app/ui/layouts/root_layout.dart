import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/routes/app_routes.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      routerDelegate: Get.rootDelegate,
      builder: (context, delegate, currentRoute) {
        final currentIndex = _currentIndex(currentRoute?.uri.toString() ?? '');

        return Scaffold(
          body: GetRouterOutlet(
            initialRoute: AppRoutes.home,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) =>
                _handleNavigation(index, delegate),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'home'.tr,
              ),
              NavigationDestination(
                icon: Icon(Icons.play_arrow_outlined),
                selectedIcon: Icon(Icons.play_arrow),
                label: 'game'.tr,
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: 'search'.tr,
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'profile'.tr,
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleNavigation(int index, GetDelegate delegate) {
    switch (index) {
      case 0:
        delegate.toNamed(AppRoutes.home);
        break;
      case 1:
        delegate.toNamed(AppRoutes.game);
        break;
      case 2:
        delegate.toNamed(AppRoutes.search);
        break;
      case 3:
        delegate.toNamed(AppRoutes.profile);
        break;
    }
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
