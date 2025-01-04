import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/pages/game_root_layout.dart';
import 'package:goadventure/app/pages/home_screen.dart';
import 'package:goadventure/app/pages/profile_screen.dart';
import 'package:goadventure/app/pages/search_page.dart';
import 'package:goadventure/app/routes/app_routes.dart';

// class RootLayout extends StatelessWidget {
//   const RootLayout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetRouterOutlet
//       bottomNavigationBar: GetBuilder<RootLayoutController>(
//         init: RootLayoutController(),
//         builder: (controller) {
//           return BottomNavigationBar(
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: "Home",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.play_arrow),
//                 label: "Game",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.search),
//                 label: "Search",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: "Profile",
//               ),
//             ],
//             currentIndex: controller.selectedIndex,
//             type: BottomNavigationBarType.fixed,
//             unselectedItemColor: Colors.grey,
//             selectedItemColor: Colors.blue,
//             onTap: (index) => controller.onItemTapped(index),
//           );
//         },
//       ),
//     );
//   }
// }

// class RootLayoutController extends GetxController {
//   int selectedIndex = 0;

//   // Map of tab indexes to their routes
//   final List<String> _routes = [
//     AppRoutes.home,
//     AppRoutes.game,
//     AppRoutes.search,
//     AppRoutes.profile,
//   ];

//   // Update the selected index and navigate to the corresponding route
//   void onItemTapped(int index) {
//     if (index != selectedIndex) {
//       selectedIndex = index;
//       update(); // Notify the UI to rebuild
//       Get.toNamed(
//         _routes[index],
//         id: 1, // Use the nested navigator key
//       );
//     }
//   }
// }

class RootLayout extends StatelessWidget {
  const RootLayout({Key? key}) : super(key: key);

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
            currentIndex: _currentIndex(currentRoute?.location ?? ''),
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
