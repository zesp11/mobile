import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/game_controller.dart';

class GameScreen extends StatelessWidget {
  // Initialize the GameController to interact with the game's data
  final GameController controller =
      Get.put(GameController(gameService: Get.find()));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Game Title'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current Game'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Current Game Tab
            Obx(() {
              // Check if the current gamebook is loaded
              if (controller.currentGamebook.value == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Game Selected Yet"),
                      const SizedBox(height: 20),
                      // Input for gamebook ID
                      ElevatedButton(
                        onPressed: () {
                          // Trigger fetching the gamebook with the provided ID
                          controller.currentGamebookId.value = 1;
                          controller.fetchGamebookData(
                              controller.currentGamebookId.value!);
                        },
                        child: const Text("Fetch test Gamebook"),
                      ),
                    ],
                  ),
                );
              }

              // Get the current gamebook and step if available
              final currentGamebook = controller.currentGamebook.value;
              final currentStep = controller.currentStep;

              if (currentStep.value == null) {
                return const Center(
                  child: Text("No steps available for the selected gamebook."),
                );
              }

              final decisions = currentStep.value!.decisions;

              // If there are no decisions, show the last step text and a restart button
              if (decisions.isEmpty) {
                print("No more decisions to be made");

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display the last step text
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Text(
                              currentStep
                                  .value!.text, // Display the last step text
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Button to restart the game
                      ElevatedButton(
                        onPressed: () {
                          // Restart the game from the first step
                          print('restart the game');
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
                  // Top text section showing the current step's description
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Text(
                            currentStep
                                .value!.text, // Display the current step text
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom buttons section for decisions
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
                                // Navigate to the next step based on the decision
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
                            reverse: true, // Start scrolling from the bottom
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
          ],
        ),
      ),
    );
  }
}
