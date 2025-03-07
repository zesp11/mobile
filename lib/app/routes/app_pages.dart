import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/pages/welcome_screen.dart';
// ... existing imports ...

class CustomPageTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve ?? Curves.easeOutCubic,
        )),
        child: child,
      ),
    );
  }
}

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => OnboardingScreen(),
      customTransition: CustomPageTransition(),
      transitionDuration: Duration(milliseconds: 400),
    ),
    // ... existing routes with the same transition settings ...
  ];
}
