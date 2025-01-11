import 'package:flutter/material.dart';
import 'package:goadventure/app/models/decision.dart';

class DecisionButtonLayout extends StatelessWidget {
  final List<Decision> decisions;
  final String layoutStyle;
  final Function(Decision) onDecisionMade;

  const DecisionButtonLayout({
    Key? key,
    required this.decisions,
    required this.layoutStyle,
    required this.onDecisionMade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handle different button layout styles
    if (layoutStyle == 'stacked') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          decisions.length,
          (index) {
            final decision = decisions[index];
            return ElevatedButton(
              onPressed: () => onDecisionMade(decision),
              child: Text(decision.text),
            );
          },
        ),
      );
    } else if (layoutStyle == 'horizontal') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          decisions.length,
          (index) {
            final decision = decisions[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => onDecisionMade(decision),
                child: Text(decision.text),
              ),
            );
          },
        ),
      );
    } else {
      // Default button layout style
      return Container();
    }
  }
}
