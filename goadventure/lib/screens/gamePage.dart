import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Center(
            child: Text(
              "This is GamePage class",
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
        ),
        Flexible(
          child: Column(
            children:
                ["Button 1", "Button 2", "Button 3", "Button 4"].map((label) {
              return Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print('$label pressed');
                    },
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
