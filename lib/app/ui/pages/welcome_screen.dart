import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  int _currentPage = 0;
  bool _isLocationEnabled = false;

  final List<Widget> _pages = [
    _OnboardingPage(
      icon: Icons.auto_awesome,
      title: "forge_legend".tr,
      description: "forge_legend_desc".tr,
      color: Color(0xFFFA802F),
    ),
    _OnboardingPage(
      icon: Icons.map,
      title: "explore_realms".tr,
      description: "explore_realms_desc".tr,
      color: Color(0xFF9C8B73),
    ),
    _OnboardingPage(
      icon: Icons.account_tree,
      title: "shape_destiny".tr,
      description: "shape_destiny_desc".tr,
      color: Color(0xFF322505),
    ),
    _LocationPermissionPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animationController.forward();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    setState(() {
      _isLocationEnabled = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'location_services_disabled'.tr,
        'enable_location_services'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.9),
        colorText: Get.theme.colorScheme.onError,
        duration: Duration(seconds: 5),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'permission_denied'.tr,
          'location_permission_required'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.9),
          colorText: Get.theme.colorScheme.onError,
          duration: Duration(seconds: 5),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'permission_denied_forever'.tr,
        'open_settings_enable_location'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.9),
        colorText: Get.theme.colorScheme.onError,
        duration: Duration(seconds: 5),
      );
      return false;
    }

    setState(() {
      _isLocationEnabled = true;
    });
    return true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                children: _pages,
              ),
              // Skip Button (top-right)
              if (_currentPage < _pages.length - 1)
                Positioned(
                  top: 40,
                  right: 20,
                  child: TextButton(
                    onPressed: () async {
                      if (!_isLocationEnabled) {
                        final hasPermission = await _handleLocationPermission();
                        if (!hasPermission) {
                          return;
                        }
                      }
                      Get.offAllNamed('/');
                    },
                    child: Text(
                      'skip'.tr,
                      style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: 16,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Next/Start Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TweenAnimationBuilder(
                        duration: Duration(milliseconds: 600),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: child,
                          );
                        },
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_currentPage < _pages.length - 1) {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              if (!_isLocationEnabled) {
                                final hasPermission =
                                    await _handleLocationPermission();
                                if (!hasPermission) {
                                  return;
                                }
                              }
                              Get.offAllNamed('/');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: theme.colorScheme.secondary,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? (_isLocationEnabled
                                    ? 'begin_adventure'.tr
                                    : 'enable_location'.tr)
                                : 'next'.tr,
                            style: TextStyle(
                              color: isDark
                                  ? theme.colorScheme.onSecondary
                                  : theme.colorScheme.onPrimary,
                              fontSize: 18,
                              fontFamily: 'MedievalSharp',
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Page Indicators with glow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.onBackground
                                    .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.secondary,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 60,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(height: 40),
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 600),
            tween: Tween<Offset>(begin: Offset(0, 20), end: Offset.zero),
            builder: (context, Offset offset, child) {
              return Transform.translate(
                offset: offset,
                child: child,
              );
            },
            child: Stack(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'MedievalSharp',
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = theme.colorScheme.secondary.withOpacity(0.5),
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'MedievalSharp',
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onBackground
                    .withOpacity(isDark ? 0.7 : 0.8),
                height: 1.4,
                fontFamily: 'Merriweather',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationPermissionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.secondary,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.location_on,
                size: 60,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(height: 40),
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 600),
            tween: Tween<Offset>(begin: Offset(0, 20), end: Offset.zero),
            builder: (context, Offset offset, child) {
              return Transform.translate(
                offset: offset,
                child: child,
              );
            },
            child: Stack(
              children: [
                Text(
                  'location_required'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'MedievalSharp',
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = theme.colorScheme.secondary.withOpacity(0.5),
                  ),
                ),
                Text(
                  'location_required'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'MedievalSharp',
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Text(
              'location_permission_explanation'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onBackground
                    .withOpacity(isDark ? 0.7 : 0.8),
                height: 1.4,
                fontFamily: 'Merriweather',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
