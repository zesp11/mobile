import 'package:get/get.dart';
import 'package:goadventure/app/controllers/search_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Inject ApiService and SearchController
    Get.find<ApiService>();
    Get.put<SearchController>(SearchController(searchService: Get.find()));
  }
}
