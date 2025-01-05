import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/controllers/home_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:goadventure/app/controllers/search_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:goadventure/app/services/api_service/developmentApiService.dart';
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
    Logger logger = _createLogger(isProduction);
    Get.put<Logger>(logger);

    // Log environment info
    logger.i("Environment: ${isProduction ? 'Production' : 'Development'}");

    // Register the API service
    _registerApiService(logger);

    // Register services using the injected ApiService
    Get.put<UserService>(UserService(apiService: Get.find()));
    Get.put<SearchService>(SearchService(apiService: Get.find()));
    Get.put<HomeService>(HomeService(apiService: Get.find()));
    Get.put<GameService>(GameService(apiService: Get.find()));

    // Register controllers that need services
    Get.put<AuthController>(AuthController(userService: Get.find()));
    Get.put<ProfileController>(ProfileController(userService: Get.find()));
    Get.put<HomeController>(HomeController(homeService: Get.find()));
    Get.put<GameController>(GameController(gameService: Get.find()));
    Get.put<SearchController>(SearchController(searchService: Get.find()));
  }

  Logger _createLogger(bool isProduction) {
    return Logger(
      level: isProduction ? Level.warning : Level.debug,
      printer: PrettyPrinter(
        methodCount:
            isProduction ? 0 : 3, // Detailed stack trace in development
        colors: !isProduction, // Disable colors in production
        dateTimeFormat: isProduction // Show timestamps in production
            ? DateTimeFormat.onlyTimeAndSinceStart
            : DateTimeFormat.none,
      ),
    );
  }

  void _registerApiService(Logger logger) {
    if (isProduction) {
      logger.w("Production API service is not implemented yet.");
      logger.e("Production API service is not implemented yet.");
      throw UnimplementedError("There is no production API yet");
      // Get.lazyPut<ApiService>(() => ProductionApiService("https://api.example.com"));
    } else {
      logger.d("Registering development API service.");
      Get.lazyPut<ApiService>(() => DevelopmentApiService());
    }
  }
}
