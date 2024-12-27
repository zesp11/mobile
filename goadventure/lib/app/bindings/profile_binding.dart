import 'package:get/get.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:goadventure/app/services/api_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Inject ApiService and UserProfileController
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<ProfileController>(
        () => ProfileController(apiService: Get.find()));
  }
}
