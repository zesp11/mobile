import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/controllers/home_controller.dart';
import 'package:gotale/app/controllers/profile_controller.dart';
import 'package:gotale/app/controllers/scenario_controller.dart';
import 'package:gotale/app/controllers/search_controller.dart';
import 'package:gotale/utils/env_config.dart';
import 'package:logger/logger.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Create and configure the logger
    final logger = Get.find<Logger>();

    // Log environment info
    logger.i("Environment: ${EnvConfig.environment}");
    logger.d("API Endpoint: ${EnvConfig.apiUrl}");

    Get.put<AuthController>(AuthController(
      userService: Get.find(),
      authService: Get.find(),
    ));
    Get.put<ProfileController>(ProfileController(userService: Get.find()));
    Get.put<HomeController>(HomeController(homeService: Get.find()));
    Get.put<GamePlayController>(GamePlayController(gameService: Get.find()));
    Get.put<GameSelectionController>(
        GameSelectionController(gameService: Get.find()));
    Get.put<ScenarioController>(ScenarioController(gameService: Get.find()));
    Get.put<SearchController>(SearchController(searchService: Get.find()));
  }
}
