import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentPage = 0;

  final List<Widget> _pages = [
    _OnboardingPage(
      icon: Icons.auto_awesome,
      title: "Forge Your Legend",
      description:
          "Embark on quests where every choice etches your story\nin the annals of this realm",
      color: Color(0xFFFA802F),
    ),
    _OnboardingPage(
      icon: Icons.map,
      title: "Explore Boundless Realms",
      description:
          "Journey through mystical lands filled with\nancient secrets and hidden dangers",
      color: Color(0xFF9C8B73),
    ),
    _OnboardingPage(
      icon: Icons.account_tree,
      title: "Shape Your Destiny",
      description:
          "Each decision branches into new possibilities\ncarving your unique path to glory",
      color: Color(0xFF322505),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF3E8CA),
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
            // Back Arrow (top-left)
            if (_currentPage > 0)
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFF322505)),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            // Skip Button (top-right)
            if (_currentPage < _pages.length - 1)
              Positioned(
                top: 40,
                right: 20,
                child: TextButton(
                  onPressed: () => Get.offAllNamed('/'),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF322505),
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
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Color(0xFFFA802F).withOpacity(0.3 * value),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: child,
                        );
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Get.offAllNamed('/');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF322505),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: Color(0xFFFA802F),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Begin Adventure'
                              : 'Next',
                          style: TextStyle(
                            color: Color(0xFFF3E8CA),
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
                              ? Color(0xFFFA802F)
                              : Color(0xFF9C8B73).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: _currentPage == index
                              ? [
                                  BoxShadow(
                                    color: Color(0xFFFA802F).withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
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
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 60,
                color: color,
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
                      ..color = Color(0xFF322505),
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'MedievalSharp',
                    color: color,
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
                color: Color(0xFF322505),
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
