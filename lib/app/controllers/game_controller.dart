import 'package:get/get.dart';
import 'package:gotale/app/models/game.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:logger/logger.dart';

// TODO: split this into game selection scenario controller
class GameSelectionController extends GetxController
    with StateMixin<List<Game>> {
  final GameService gameService;
  final logger = Get.find<Logger>();

  // List of available gamebooks
  var availableGamebooks = <Scenario>[].obs;
  var isAvailableGamebooksLoading = false.obs;

  // List of games in progress
  var gamesInProgress = RxList<Game>();
  var isGamesInProgressLoading = false.obs;

  GameSelectionController({required this.gameService});

  @override
  void onInit() {
    super.onInit();
    fetchAvailableGamebooks();
    fetchGamesInProgress();

    super.onReady();
  }

  // Fetch the list of available gamebooks
  Future<void> fetchAvailableGamebooks() async {
    isAvailableGamebooksLoading.value = true;
    try {
      logger.i("[DEV_DEBUG] Fetching available gamebooks");
      final gamebooks = await gameService.fetchAvailableGamebooks();
      availableGamebooks.assignAll(gamebooks);
    } catch (e) {
      logger.e("Error fetching available gamebooks: $e");
    } finally {
      isAvailableGamebooksLoading.value = false;
    }
  }

  // Fetch games in progress
  Future<void> fetchGamesInProgress() async {
    isGamesInProgressLoading.value = true;
    try {
      change([], status: RxStatus.loading());
      final games = await gameService.fetchGamesInProgress();
      if (games.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(games, status: RxStatus.success());
      }
    } catch (e) {
      logger.e("Error fetching games in progress: $e");
      change([], status: RxStatus.error(e.toString()));
    } finally {
      isGamesInProgressLoading.value = false;
    }
  }

  // Resume a game
  Future<void> resumeGame(int gameId) async {
    try {
      logger.i("[DEV_DEBUG] Resuming game with ID: $gameId");
      await gameService.fetchGamebookData(gameId);
    } catch (e) {
      logger.e("Error resuming game: $e");
      rethrow;
    }
  }
}
