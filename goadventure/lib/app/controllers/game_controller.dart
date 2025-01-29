import 'package:get/get.dart';
import 'package:goadventure/app/models/decision.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/models/step.dart';
import 'package:goadventure/app/services/game_service.dart';
import 'package:logger/logger.dart';

// This screen focuses on the active game session.
// It manages the game logic, decisions, and interactions with other players.
// TODO: split this into GameRunning and GamesController
class GameSelectionController extends GetxController {
  final GameService gameService;
  final logger = Get.find<Logger>();

  // List of available gamebooks
  var availableGamebooks = <Gamebook>[].obs;
  var isAvailableGamebooksLoading = false.obs;

  GameSelectionController({required this.gameService});

  @override
  void onInit() {
    super.onInit();
    fetchAvailableGamebooks();
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
}

class GamePlayController extends GetxController with StateMixin {
  final GameService gameService;
  final logger = Get.find<Logger>();

  // Reactive variable for the selected gamebook
  Rx<Gamebook?> currentGamebook = Rx<Gamebook?>(null);

  final showPostDecisionMessage = false.obs;
  final hasArrivedAtLocation = false.obs;
  void confirmArrival() {
    showPostDecisionMessage.value = false;
    hasArrivedAtLocation.value = true;
  }

  // Reactive variable for the current step of the gamebook
  Rx<Step?> currentStep = Rx<Step?>(null);

  // History to store the sequence of decisions and steps
  var gameHistory = RxList<String>([]);

  var isCurrentGamebookLoading = false.obs;

  GamePlayController({required this.gameService});

  // Fetch the current gamebook data and initialize the first step
  Future<void> fetchGamebookData(int id) async {
    change(null, status: RxStatus.loading()); // Set the state to loading
    gameHistory.clear();
    try {
      final gamebook = await gameService.fetchGamebook(id);
      currentGamebook.value = gamebook;
      hasArrivedAtLocation.value = false;
      showPostDecisionMessage.value = false;

      // Set the first step if available
      if (gamebook.steps.isNotEmpty) {
        currentStep.value = gamebook.steps.first;
      }
      change(null, status: RxStatus.success()); // Update status to success
    } catch (e) {
      logger.e("Error fetching gamebook: $e");
      change(null,
          status: RxStatus.error("Error fetching gamebook")); // Handle error
    }
  }

  void updateCurrentGamebook(int id) {
    fetchGamebookData(id);
  }

  void makeDecision(Decision decision) {
    showPostDecisionMessage.value = true;
    hasArrivedAtLocation.value = false;
    if (currentStep.value != null) {
      gameHistory.add("Step: ${currentStep.value!.text}");
    }

    gameHistory.add("Decision: ${decision.text}");

    // Find the next step based on the decision
    Step? nextStep = currentGamebook.value?.steps.firstWhere(
      (step) => step.id == decision.nextStepId,
      orElse: () => Step(
        id: decision.nextStepId,
        title: "Next Step",
        text: "This is the next step.",
        latitude: 0.0,
        longitude: 0.0,
        decisions: [],
      ),
    );

    if (nextStep != null) {
      currentStep.value = nextStep;
      hasArrivedAtLocation.value = false;
    }
  }

  bool isGamebookSelected() {
    return currentGamebook.value != null;
  }

  String getGameHistory() {
    if (gameHistory.isEmpty) {
      return "There is no history yet, travel around the world to create your own...";
    } else {
      return gameHistory.join('\n');
    }
  }
}
