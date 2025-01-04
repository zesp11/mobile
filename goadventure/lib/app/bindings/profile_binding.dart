import 'package:get/get.dart';
import 'package:goadventure/app/controllers/profile_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:goadventure/app/services/api_service/developmentApiService.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Inject ApiService and UserProfileController
    Get.put<ApiService>(DevelopmentApiService());
    Get.put<ProfileController>(ProfileController(userService: Get.find()));
  }
}
