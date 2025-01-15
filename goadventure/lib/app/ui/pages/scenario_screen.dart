import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goadventure/app/controllers/auth_controller.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/routes/app_routes.dart';
import 'package:goadventure/app/services/game_service.dart';

class ScenarioScreen extends StatelessWidget {
  final GameService service = Get.find<GameService>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Get the 'id' parameter from the URL
    final String id = Get.parameters['id'] ?? 'Unknown';

    return Scaffold(
      body: FutureBuilder<Gamebook>(
        future: Get.arguments == null
            ? service.fetchGamebook(int.tryParse(id) ?? 0)
            : Future.value(Get.arguments as Gamebook),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Error state
            );
          } else if (snapshot.hasData) {
            final gamebook = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: Text(gamebook
                    .name), // Set the dynamic title based on fetched data
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID: $id',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the author's profile screen
                              Get.toNamed('/profile/${gamebook.authorId}');
                            },
                            child: Text(
                              'AuthorID: ${gamebook.authorId}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration
                                    .underline, // Underline to signify it's a link
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Description Section
                      Text(
                        'description'.tr,
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
                        'dates'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            '${"start_date".tr}: ${gamebook.startDate.toLocal().toString().split(' ')[0]}',
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
                              '${"end_date".tr}: ${gamebook.endDate!.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      SizedBox(height: 16),

                      // Steps Section
                      Text(
                        'steps'.tr,
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
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row with Expanded to make the button fill horizontal space
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: authController.isAuthenticated
                                ? () {
                                    // Navigate to the gameplay screen or start the game
                                    final gamebook_destination =
                                        AppRoutes.gameDetail.replaceFirst(
                                            ":id", gamebook.id.toString());
                                    Get.toNamed(gamebook_destination);
                                  }
                                : null, // Disable the button if the user is not authenticated
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: authController.isAuthenticated
                                  ? Colors.blue
                                  : Colors.blue.withOpacity(
                                      0.5), // Maintain the blue color with reduced opacity when disabled
                            ),
                            child: Text(
                              'play_game'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!authController.isAuthenticated)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'login_needed'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
