import 'package:get/get.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:logger/logger.dart';

class ScenarioController extends GetxController
    with StateMixin<List<Scenario>> {
  final GameService gameService;
  final logger = Get.find<Logger>();

  // List of available gamebooks
  // var availableGamebooks = <Scenario>[].obs;
  ScenarioController({required this.gameService});

  @override
  void onInit() {
    super.onInit();
    fetchAvailableGamebooks();

    super.onReady();
  }

  // Fetch the list of available gamebooks
  Future<void> fetchAvailableGamebooks() async {
    change([], status: RxStatus.loading());
    try {
      logger.i("[DEV_DEBUG] Fetching available gamebooks");
      final gamebooks = await gameService.fetchAvailableGamebooks();
      // availableGamebooks.assignAll(gamebooks);
      change(gamebooks, status: RxStatus.success());
    } catch (e) {
      change([], status: RxStatus.error(e.toString()));
      logger.e("Error fetching available gamebooks: $e");
    }
  }
}
