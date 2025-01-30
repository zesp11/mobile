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
  final Logger logger = Get.find<Logger>();
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
            onLoading: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            tabs: [
              Obx(
                () => Tab(
                  text: 'decision'.tr,
                  icon: Icon(
                    controller.hasArrivedAtLocation.value
                        ? Icons.check_circle
                        : Icons.location_disabled,
                    color: controller.hasArrivedAtLocation.value
                        ? Theme.of(context)
                            .colorScheme
                            .secondary // Use accent color when active
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3), // Use muted accent when disabled
                  ),
                ),
              ),
              Tab(
                text: 'history'.tr,
                icon: Icon(Icons.article,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              Tab(
                text: 'map'.tr,
                icon: Icon(Icons.map,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.secondary),
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
          onLoading: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          onEmpty: Center(
            child: Text(
              'No gamebook found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          onError: (error) => Center(
            child: Text(
              error ?? 'Error occurred',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
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
        if (controller.currentGamebook.value == null) return;
        final gameBookId = controller.currentGamebook.value!.id;
        final scenarioLink =
            AppRoutes.scenarioDetail.replaceFirst(":id", gameBookId.toString());
        Get.toNamed(scenarioLink, arguments: controller.currentGamebook.value);
      },
      child: Obx(() {
        return Text(
          controller.currentGamebook.value!.title,
          style: Theme.of(context).textTheme.titleLarge,
        );
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
      if (controller.showPostDecisionMessage.value) {
        return _buildDecisionSuccessMessage(context);
      }
      if (!controller.hasArrivedAtLocation.value) {
        return _buildArrivalRequiredMessage(context);
      }
      return _buildDecisionContent(context);
    });
  }

  Widget _buildDecisionSuccessMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 60,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            "Decision Recorded!",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            "Proceed to the next location\nto continue your adventure",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: Icon(Icons.map,
                color: Theme.of(context).colorScheme.onSecondary),
            label: Text(
              "Navigate to Next Location",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            onPressed: () => DefaultTabController.of(context)?.animateTo(2),
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
          Icon(
            Icons.location_off,
            size: 50,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            "Location Required",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            "Confirm your arrival at the current location\nin the Map tab to continue",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            icon: Icon(Icons.map,
                color: Theme.of(context).colorScheme.onSecondary),
            label: Text(
              "Go to Map",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            onPressed: () => DefaultTabController.of(context)?.animateTo(2),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionContent(BuildContext context) {
    final currentStep = controller.currentStep.value;
    if (currentStep == null) {
      return Center(
        child: Text(
          "No steps available",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
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
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller
                  .fetchGamebookData(controller.currentGamebook.value!.id),
              child: Text(
                "Start From the Beginning",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
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
                style: Theme.of(context).textTheme.bodyLarge,
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
          Text(
            "Current Location",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Obx(() => Text(
                controller.hasArrivedAtLocation.value
                    ? "You've arrived at the location!"
                    : "Travel to the marked location...",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          const SizedBox(height: 30),
          Obx(() {
            if (controller.hasArrivedAtLocation.value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        DefaultTabController.of(context)?.animateTo(0),
                    child: Text(
                      "Go to Decisions",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 30,
                  ),
                ],
              );
            }
            return ElevatedButton(
              onPressed: () => controller.confirmArrival(),
              child: Text(
                "Confirm Arrival",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
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
        () => controller.gameHistory.isEmpty
            ? Center(
                child: Text(
                  "No history yet",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: controller.gameHistory.length,
                itemBuilder: (context, index) {
                  final reversedIndex =
                      controller.gameHistory.length - 1 - index;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    title: Text(
                      controller.gameHistory[reversedIndex],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
