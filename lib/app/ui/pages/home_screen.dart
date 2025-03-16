import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/home_controller.dart';
import 'package:gotale/app/ui/widgets/recommended_scenarios_widget.dart';
import 'package:gotale/app/ui/widgets/resume_last_game_section.dart';
import 'package:gotale/app/ui/widgets/search_game_section.dart';
import 'package:gotale/app/ui/widgets/profile_summary.dart';

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
              ProfileSummaryWidget(),
              const Divider(),
              ResumeLastGameSection(),
              const Divider(),
            ],
            const SearchGamesSection(),
            // TODO:
            // const Divider(),
            // const NearbyGamesWidget(),
            const Divider(),
            RecommendedScenariosWidget(),
          ],
        ),
      ),
    );
  }
}
