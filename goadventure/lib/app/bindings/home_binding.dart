import 'package:get/get.dart';
import 'package:goadventure/app/controllers/home_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:goadventure/app/services/api_service/developmentApiService.dart';
import 'package:goadventure/app/services/home_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Inject HomeService
    Get.put<ApiService>(DevelopmentApiService());
    Get.put<HomeService>(HomeService(apiService: Get.find()));
    Get.put<HomeController>(HomeController(homeService: Get.find()));
  }
}
