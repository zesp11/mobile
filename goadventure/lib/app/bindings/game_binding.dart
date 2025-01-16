import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    // Inject ApiService and CurrentGameController
    Get.find<ApiService>();
    Get.find<GameSelectionController>();
    Get.find<GamePlayController>();
  }
}
