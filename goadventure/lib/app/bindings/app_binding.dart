import 'package:get/get.dart';
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

class AppBindings extends Bindings {
  AppBindings();

  @override
  void dependencies() {
    if (isProduction) {
      throw UnimplementedError("There is no production API yet");
      // Get.lazyPut<ApiService>(() => ProductionApiService("https://api.example.com"));
    } else {
      Get.lazyPut<ApiService>(() => DevelopmentApiService());
    }

    // Register UserService using the injected ApiService
    Get.put<UserService>(UserService(apiService: Get.find()));
    Get.put<SearchService>(SearchService(apiService: Get.find()));
    Get.put<HomeService>(HomeService(apiService: Get.find()));
    Get.put<GameService>(GameService(apiService: Get.find()));

    // Register controllers that need ApiService
    Get.put<ProfileController>(ProfileController(userService: Get.find()));
    Get.put<HomeController>(HomeController(homeService: Get.find()));
    Get.put<GameController>(GameController(gameService: Get.find()));
    Get.put<SearchController>(SearchController(searchService: Get.find()));
  }
}
