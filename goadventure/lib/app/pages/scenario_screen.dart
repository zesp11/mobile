import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/routes/app_routes.dart';

class ScenarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the parameters and arguments
    final String id =
        Get.parameters['id'] ?? 'Unknown'; // Get the 'id' parameter
    final Gamebook gamebook =
        Get.arguments as Gamebook; // Retrieve the passed Gamebook object

    return Scaffold(
      appBar: AppBar(
        title: Text(
            gamebook.name), // Display the name of the Gamebook in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Text(
                gamebook.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'ID: $id',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),

              // Description Section
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                gamebook.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),

              // Date Section
              Text(
                'Dates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Start Date: ${gamebook.startDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 4),
              if (gamebook.endDate != null)
                Row(
                  children: [
                    Icon(Icons.event, size: 18, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'End Date: ${gamebook.endDate!.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              SizedBox(height: 16),

              // Steps Section
              Text(
                'Steps',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              if (gamebook.steps.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: gamebook.steps.length,
                  itemBuilder: (context, index) {
                    final step = gamebook.steps[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                        ),
                        title: Text(step.text),
                        subtitle: Text('Step ID: ${step.id}'),
                      ),
                    );
                  },
                )
              else
                Text(
                  'No steps available.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the gameplay screen or start the game
            final gamebook_destination = AppRoutes.gameDetail
                .replaceFirst(":id", gamebook.id.toString());
            Get.toNamed(gamebook_destination);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: Colors.blue, // Primary button color
          ),
          child: Text(
            'Play Game',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
