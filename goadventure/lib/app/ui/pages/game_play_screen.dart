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
- TODO: fix clunky lag when switching game 
  -> show loading indicator ??? Maybe skeleton ???
 */
class GamePlayScreen extends StatelessWidget {
  final GameController controller = Get.find();
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
          title: GestureDetector(
            onTap: () {
              logger.i(
                  "User wants to see /scenario/${controller.currentGamebook.value!.id}");
              if (controller.currentGamebook.value == null) {
                logger.d(
                    "[GamePlayScreen] controller.currentGamebook == null -> do nothing");
                return;
              }
              final gameBookId = controller.currentGamebook.value!.id;
              final scenarioLink = AppRoutes.scenarioDetail
                  .replaceFirst(":id", gameBookId.toString());
              Get.toNamed(scenarioLink,
                  arguments: controller.currentGamebook.value);
            },
            // TODO: provide widget for that
            child: Obx(() {
              return Text(controller.currentGamebook.value!.title);
            }),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'decision'.tr),
              Tab(text: 'history'.tr),
              Tab(text: 'map'.tr),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: onReturnToSelection, // Go back to game selection
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Decision Tab
            Obx(() {
              final currentStep = controller.currentStep;
              if (currentStep.value == null) {
                return const Center(
                    child:
                        Text("No steps available for the selected gamebook."));
              }

              final decisions = currentStep.value!.decisions;
              final buttonLayout = Get.find<SettingsController>()
                  .layoutStyle
                  .value; // Get button layout from settings

              if (decisions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Text(
                            currentStep.value!.text,
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          controller.currentGamebookId.value = 1;
                          controller.fetchGamebookData(
                              controller.currentGamebookId.value!);
                        },
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
                          currentStep.value!.text,
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
            }),
            // History Tab
            Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(
                      () => Text(
                        controller.getGameHistory(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ))),
            // Map Tab
            const Center(child: Text("Map functionality will go here")),
          ],
        ),
      ),
    );
  }
}
