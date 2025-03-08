import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/home_controller.dart';
import 'package:gotale/app/ui/widgets/recommend_games_section.dart';
import 'package:gotale/app/ui/widgets/resume_last_game_section.dart';
import 'package:gotale/app/ui/widgets/search_game_section.dart';
import 'package:gotale/app/ui/widgets/user_summary.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller =
      Get.put(HomeController(homeService: Get.find()));
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (authController.isAuthenticated) ...[
              UserSummaryWidget(),
              const Divider(),
              ResumeLastGameSection(),
              const Divider(),
            ],
            const SearchGamesSection(),
            // const Divider(),
            // const LastGameWidget(),
            // TODO:
            // const Divider(),
            // const NearbyGamesWidget(),
            const Divider(),
            RecommendedGamesWidget(),
          ],
        ),
      ),
    );
  }
}
