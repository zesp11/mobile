import 'package:get/get.dart';
import 'package:goadventure/app/controllers/home_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:goadventure/app/services/api_service/developmentApiService.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Inject ApiService and GamebookController
    Get.lazyPut<ApiService>(() => DevelopmentApiService());
    Get.lazyPut<HomeController>(() => HomeController(apiService: Get.find()));
  }
}
