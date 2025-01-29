import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';
import 'package:goadventure/app/controllers/settings_controller.dart';
import 'package:goadventure/app/routes/app_routes.dart';
import 'package:goadventure/app/ui/widgets/decision_buttons.dart';
import 'package:logger/web.dart';

/*
- TODO: the game should have in top left corner somekind of icon/title that is
  clickable and allows to see main page of given game
- TODO: list players that participate in given game (only in version 3.0)
- TODO: remember game after switching tabs.
- TODO: maybe show skeleton instead of loading circle
 */
class GamePlayScreen extends StatelessWidget {
  final GamePlayController controller = Get.find();
  final logger = Get.find<Logger>();
  final VoidCallback onReturnToSelection;

  GamePlayScreen({required this.onReturnToSelection});

  @override
  Widget build(BuildContext context) {
    final gamebookId = Get.parameters['id']!;
    controller.fetchGamebookData(int.parse(gamebookId));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: controller.obx(
            (state) => GameTitle(logger: logger, controller: controller),
            onLoading: const CircularProgressIndicator(),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Obx(
                () => Tab(
                  text: 'decision'.tr,
                  icon: controller.hasArrivedAtLocation.value
                      ? const Icon(Icons.check_circle)
                      : const Icon(
                          Icons.location_disabled,
                        ),
                ),
              ),
              Tab(
                text: 'history'.tr,
                icon: Icon(Icons.article),
              ),
              Tab(
                text: 'map'.tr,
                icon: Icon(Icons.map),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: onReturnToSelection,
            ),
          ],
        ),
        body: controller.obx(
          (state) => TabBarView(
            children: [
              DecisionTab(),
              StoryTab(),
              MapWidget(),
            ],
          ),
          onLoading: const Center(child: CircularProgressIndicator()),
          onEmpty: const Center(child: Text('No gamebook found')),
          onError: (error) => Center(child: Text(error ?? 'Error occurred')),
        ),
      ),
    );
  }
}

class GameTitle extends StatelessWidget {
  const GameTitle({
    super.key,
    required this.logger,
    required this.controller,
  });

  final Logger logger;
  final GamePlayController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logger.i(
            "User wants to see /scenario/${controller.currentGamebook.value!.id}");
        if (controller.currentGamebook.value == null) {
          logger.d(
              "[GamePlayScreen] controller.currentGamebook == null -> do nothing");
          return;
        }
        final gameBookId = controller.currentGamebook.value!.id;
        final scenarioLink =
            AppRoutes.scenarioDetail.replaceFirst(":id", gameBookId.toString());
        Get.toNamed(scenarioLink, arguments: controller.currentGamebook.value);
      },
      // TODO: provide widget for that
      child: Obx(() {
        return Text(controller.currentGamebook.value!.title);
      }),
    );
  }
}

class DecisionTab extends StatelessWidget {
  DecisionTab({super.key});
  final controller = Get.find<GamePlayController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show success message after decision
      if (controller.showPostDecisionMessage.value) {
        return _buildDecisionSuccessMessage(context);
      }

      // Show blocking message if not arrived
      if (!controller.hasArrivedAtLocation.value) {
        return _buildArrivalRequiredMessage(context);
      }

      // Original decision content when arrived
      return _buildDecisionContent(context);
    });
  }

  Widget _buildDecisionSuccessMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
          const SizedBox(height: 20),
          Text(
            "Decision Recorded!",
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Proceed to the next location\nto continue your adventure",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.map),
            label: const Text("Navigate to Next Location"),
            onPressed: () {
              DefaultTabController.of(context)
                  ?.animateTo(2); // Switch to Map tab
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrivalRequiredMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 50),
          const SizedBox(height: 20),
          Text(
            "Location Required",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Confirm your arrival at the current location\nin the Map tab to continue",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            icon: const Icon(Icons.map),
            label: const Text("Go to Map"),
            onPressed: () {
              // Switch to Map tab
              DefaultTabController.of(context)?.animateTo(2);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionContent(BuildContext context) {
    final currentStep = controller.currentStep.value;
    if (currentStep == null) {
      return const Center(child: Text("No steps available"));
    }

    final decisions = currentStep.decisions;
    final buttonLayout = Get.find<SettingsController>().layoutStyle.value;

    if (decisions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  currentStep.text,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller
                  .fetchGamebookData(controller.currentGamebook.value!.id),
              child: const Text("Start From the Beginning"),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(
                currentStep.text,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DecisionButtonLayout(
              decisions: decisions,
              layoutStyle: buttonLayout,
              onDecisionMade: controller.makeDecision,
            ),
          ),
        ),
      ],
    );
  }
}

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GamePlayController>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Current Location", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Obx(() => Text(
                controller.hasArrivedAtLocation.value
                    ? "You've arrived at the location!"
                    : "Travel to the marked location...",
                style: const TextStyle(fontSize: 16),
              )),
          const SizedBox(height: 30),
          Obx(() {
            if (controller.hasArrivedAtLocation.value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      DefaultTabController.of(context)
                          ?.animateTo(0); // Switch to Decision tab
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                    ),
                    child: const Text("Go to Decisions"),
                  ),
                  const SizedBox(width: 20),
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                ],
              );
            }
            return ElevatedButton(
              onPressed: () => controller.confirmArrival(),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              ),
              child: const Text("Confirm Arrival"),
            );
          }),
        ],
      ),
    );
  }
}

class StoryTab extends StatelessWidget {
  /* 
  TODO: improve the story tab, becasue there should be username with 
  user avatar what decision have been made 
  FIXME: when there is no history it should be shown
  */
  StoryTab({super.key});
  final controller = Get.find<GamePlayController>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Scroll to bottom whenever the history updates
    ever(controller.gameHistory, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(
        () => ListView.builder(
          controller: _scrollController,
          reverse: true, // Start from bottom
          itemCount: controller.gameHistory.length,
          itemBuilder: (context, index) {
            final reversedIndex = controller.gameHistory.length - 1 - index;
            return Text(
              controller.gameHistory[reversedIndex],
              style: const TextStyle(fontSize: 16),
            );
          },
        ),
      ),
    );
  }
}
