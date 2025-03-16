import 'package:get/get.dart';
import 'package:gotale/app/models/game.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:logger/logger.dart';

class GameSelectionController extends GetxController
    with StateMixin<List<Game>> {
  final GameService gameService;
  final logger = Get.find<Logger>();

  // List of games in progress
  var gamesInProgress = RxList<Game>();
  GameSelectionController({required this.gameService});

  @override
  void onInit() {
    super.onInit();
    // fetchAvailableGamebooks();
    fetchGamesInProgress();

    super.onReady();
  }

  // Fetch games in progress
  Future<void> fetchGamesInProgress() async {
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
