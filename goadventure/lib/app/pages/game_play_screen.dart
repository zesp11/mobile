import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';

/*
- TODO: the game should have in top left corner somekind of icon/title that is
  clickable and allows to see main page of given game
- TODO: list players that participate in given game (only in version 3.0)
- TODO: remember game after switching tabs.
- TODO: fix clunky lag when switching game.
 */
class GamePlayScreen extends StatelessWidget {
  final GameController controller = Get.find();
  final VoidCallback
      onReturnToSelection; // Callback to go back to selection screen

  GamePlayScreen({required this.onReturnToSelection});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs: Decision, History, Map
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Game Title'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Decision'),
              Tab(text: 'History'),
              Tab(text: 'Map'),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          decisions.length,
                          (index) {
                            final decision = decisions[index];
                            return ElevatedButton(
                              onPressed: () {
                                controller.makeDecision(decision);
                              },
                              child: Text(decision.text),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),

            // History Tab
            Center(
              child: Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Obx(() {
                        return Expanded(
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Text(
                              controller.getGameHistory().isEmpty
                                  ? "No history yet. Travel around the world and create your own adventure!"
                                  : controller.getGameHistory(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // Map Tab (just a placeholder for now)
            const Center(child: Text("Map functionality will go here")),
          ],
        ),
      ),
    );
  }
}
