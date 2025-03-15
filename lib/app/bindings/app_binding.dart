import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:gotale/app/controllers/home_controller.dart';
import 'package:gotale/app/controllers/profile_controller.dart';
import 'package:gotale/app/controllers/search_controller.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:gotale/app/services/api_service/productionApiService.dart';
import 'package:gotale/app/services/auth_service.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:gotale/app/services/home_service.dart';
import 'package:gotale/app/services/search_service.dart';
import 'package:gotale/app/services/user_service.dart';
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

    // Register the API service
    _registerApiService(logger);

    // Register services using the injected ApiService
    Get.put<UserService>(UserService(apiService: Get.find()));
    Get.put<SearchService>(SearchService(apiService: Get.find()));
    Get.put<HomeService>(HomeService(apiService: Get.find()));
    Get.put<GameService>(GameService(apiService: Get.find()));
    Get.put<AuthService>(AuthService(apiService: Get.find()));
    Get.put<FlutterSecureStorage>(FlutterSecureStorage());

    Get.put<AuthController>(AuthController(
      userService: Get.find(),
      authService: Get.find(),
    ));
    Get.put<ProfileController>(ProfileController(userService: Get.find()));
    Get.put<HomeController>(HomeController(homeService: Get.find()));
    Get.put<GamePlayController>(GamePlayController(gameService: Get.find()));
    Get.put<GameSelectionController>(
        GameSelectionController(gameService: Get.find()));
    Get.put<SearchController>(SearchController(searchService: Get.find()));
  }

  void _registerApiService(Logger logger) {
    if (EnvConfig.isProduction || EnvConfig.isDebugProd) {
      logger.d("Registering production API service");
      Get.lazyPut<ApiService>(() => ProductionApiService());
    } else {
      logger.d("Registering development API service.");
      logger.e("Unimplemented");
      UnimplementedError("Development server is not implemented");
      // Get.lazyPut<ApiService>(
      //     () => DevelopmentApiService(delay: Duration(seconds: 2)));
    }
  }
}
