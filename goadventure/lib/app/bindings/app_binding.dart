import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/controllers/home_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:goadventure/app/controllers/search_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:goadventure/app/services/api_service/developmentApiService.dart';
import 'package:goadventure/app/services/auth_service.dart';
import 'package:goadventure/app/services/game_service.dart';
import 'package:goadventure/app/services/home_service.dart';
import 'package:goadventure/app/services/search_service.dart';
import 'package:goadventure/app/services/user_service.dart';
import 'package:goadventure/main.dart';
import 'package:logger/logger.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Create and configure the logger
    final logger = Get.find<Logger>();

    // Log environment info
    logger.i("Environment: ${isProduction ? 'Production' : 'Development'}");

    // Register the API service
    _registerApiService(logger);

    // Register services using the injected ApiService
    Get.put<UserService>(UserService(apiService: Get.find()));
    Get.put<SearchService>(SearchService(apiService: Get.find()));
    Get.put<HomeService>(HomeService(apiService: Get.find()));
    Get.put<GameService>(GameService(apiService: Get.find()));
    Get.put<AuthService>(AuthService(apiService: Get.find()));

    Get.put<AuthController>(AuthController(
      userService: Get.find(),
      authService: Get.find(),
    ));
    Get.put<ProfileController>(ProfileController(userService: Get.find()));
    Get.put<HomeController>(HomeController(homeService: Get.find()));
    Get.put<GameController>(GameController(gameService: Get.find()));
    Get.put<SearchController>(SearchController(searchService: Get.find()));
  }

  void _registerApiService(Logger logger) {
    if (isProduction) {
      logger.e("Production API service is not implemented yet.");
      throw UnimplementedError("There is no production API yet");
      // Get.lazyPut<ApiService>(() => ProductionApiService("https://api.example.com"));
    } else {
      logger.d("Registering development API service.");
      Get.lazyPut<ApiService>(
          () => DevelopmentApiService(delay: Duration(seconds: 2)));
    }
  }
}
