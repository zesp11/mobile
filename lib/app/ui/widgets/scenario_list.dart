import 'package:flutter/material.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/ui/widgets/scenario_item.dart';

class ScenarioListView extends StatelessWidget {
  final List<Scenario> gamebooks;
  final AuthController authController;
  final VoidCallback onGameSelected;
  final VoidCallback onScenarioSelected;

  const ScenarioListView({
    Key? key,
    required this.gamebooks,
    required this.authController,
    required this.onGameSelected,
    required this.onScenarioSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gamebooks.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final gamebook = gamebooks[index];
        return ScenarioCard(
          gamebook: gamebook,
          authController: authController,
          onGameSelected: onGameSelected,
          onScenarioSelected: onScenarioSelected,
        );
      },
    );
  }
}
