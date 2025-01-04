import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO: totally fix that... (rewrite)
class ScenarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the parameter using GetX's parameter handling
    final String id =
        Get.parameters['id'] ?? 'Unknown'; // Get the 'id' parameter

    return Scaffold(
      appBar: AppBar(
        title: Text('Scenario $id'),
      ),
      body: Center(
        child: Text('Scenario $id'), // Display the scenario ID
      ),
    );
  }
}
