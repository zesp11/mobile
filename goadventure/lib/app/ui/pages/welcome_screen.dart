import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                  SizedBox(height: 30),
                  // Page Indicators
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
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 60,
              color: color,
            ),
          ),
          SizedBox(height: 40),
          Stack(
            children: [
              // Text border
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
              // Main text
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
          SizedBox(height: 30),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF322505),
              height: 1.4,
              fontFamily: 'Merriweather',
            ),
          ),
        ],
      ),
    );
  }
}
