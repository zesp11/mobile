import 'package:get/get.dart';
import 'package:goadventure/app/controllers/search_controller.dart';
import 'package:goadventure/app/services/api_service.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Inject ApiService and SearchController
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<SearchController>(
        () => SearchController(apiService: Get.find()));
  }
}
