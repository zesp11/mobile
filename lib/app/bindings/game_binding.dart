import 'package:get/get.dart';
import 'package:gotale/app/controllers/game_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/services/api_service/api_service.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    // Inject ApiService and CurrentGameController
    Get.find<ApiService>();
    Get.find<GameSelectionController>();
    Get.find<GamePlayController>();
  }
}
