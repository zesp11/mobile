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
            initialRoute: AppRoutes.home,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex(currentRoute?.uri.toString() ?? ''),
            onTap: (index) => _handleNavigation(index, delegate),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xFFFA802F), // Accent color
            unselectedItemColor:
                Color(0xFF9C8B73).withOpacity(0.6), // Secondary
            backgroundColor: Color(0xFFF3E8CA), // Background color
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF322505), // Foreground
            ),
            unselectedLabelStyle: TextStyle(
              color: Color(0xFF9C8B73), // Secondary
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'home'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_arrow_outlined),
                activeIcon: Icon(Icons.play_arrow),
                label: 'game'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: 'search'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
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
