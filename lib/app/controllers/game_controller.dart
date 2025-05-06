import 'package:get/get.dart';
import 'package:gotale/app/models/game.dart';
import 'package:gotale/app/models/game_in_progress.dart';
import 'package:gotale/app/services/game_service.dart';
import 'package:logger/logger.dart';

class GameSelectionController extends GetxController
    with StateMixin<List<GameInProgress>> {
  final GameService gameService;
  final logger = Get.find<Logger>();
  var includeFinished = false.obs;

  // List of games in progress
  var gamesInProgress = RxList<Game>();
  GameSelectionController({required this.gameService});

  @override
  void onInit() {
    super.onInit();
    fetchGamesInProgress();

    super.onReady();
  }

  // Fetch games in progress
  // Modify the fetch method to accept includeFinished parameter
  Future<void> fetchGamesInProgress({bool includeFinished = false}) async {
    try {
      change([], status: RxStatus.loading());
      final games = await gameService.fetchGamesInProgress(
        includeFinished: includeFinished,
      );
      if (games.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(games, status: RxStatus.success());
      }
    } catch (e) {
      logger.e("Error fetching games: $e");
      change([], status: RxStatus.error(e.toString()));
    }
  }

  // Add this toggle method
  void toggleIncludeFinished(bool value) {
    includeFinished.value = value;
    fetchGamesInProgress(includeFinished: value);
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
