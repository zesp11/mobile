import 'package:get/get.dart';
import 'package:gotale/app/controllers/home_controller.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:gotale/app/services/home_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Inject HomeService
    Get.find<ApiService>();
    Get.put<HomeService>(HomeService(apiService: Get.find()));
    Get.put<HomeController>(HomeController(homeService: Get.find()));
  }
}
