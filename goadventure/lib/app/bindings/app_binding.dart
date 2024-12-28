import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/controllers/home_controller.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:goadventure/app/controllers/search_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:goadventure/app/services/api_service/developmentApiService.dart';
import 'package:goadventure/app/services/home_service.dart';
import 'package:goadventure/app/services/search_service.dart';
import 'package:goadventure/app/services/user_service.dart';

class AppBindings extends Bindings {
  final bool isProduction;

  AppBindings({required this.isProduction});

  @override
  void dependencies() {
    if (isProduction) {
      throw UnimplementedError("There is no production API yet");
      // Get.lazyPut<ApiService>(() => ProductionApiService("https://api.example.com"));
    } else {
      Get.lazyPut<ApiService>(() => DevelopmentApiService());
    }

    // Register UserService using the injected ApiService
    Get.lazyPut<UserService>(() => UserService(apiService: Get.find()));
    Get.lazyPut<SearchService>(() => SearchService(apiService: Get.find()));
    Get.lazyPut<HomeService>(() => HomeService(apiService: Get.find()));

    // Register controllers that need ApiService
    Get.lazyPut<ProfileController>(
        () => ProfileController(userService: Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(homeService: Get.find()));
    Get.lazyPut<GameController>(() => GameController(apiService: Get.find()));
    Get.lazyPut<SearchController>(
        () => SearchController(searchService: Get.find()));
  }
}
