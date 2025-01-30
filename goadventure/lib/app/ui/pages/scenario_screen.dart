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
    final String id = Get.parameters['id'] ?? 'Unknown';

    return Scaffold(
      body: FutureBuilder<Gamebook>(
        future: Get.arguments == null
            ? service.fetchGamebook(int.tryParse(id) ?? 0)
            : Future.value(Get.arguments as Gamebook),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Color(0xFFFA802F), // Accent color
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Color(0xFF9C8B73)), // Secondary color
              ),
            );
          } else if (snapshot.hasData) {
            final gamebook = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  gamebook.name,
                  style: TextStyle(
                    color: Color(0xFFFA802F), // Accent color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Color(0xFF322505), // Foreground color
                iconTheme: IconThemeData(color: Color(0xFFFA802F)), // Accent
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gamebook.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF322505), // Foreground
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
                              color: Color(0xFF9C8B73), // Secondary
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Get.toNamed('/profile/${gamebook.authorId}'),
                            child: Text(
                              'AuthorID: ${gamebook.authorId}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFA802F), // Accent
                                decoration: TextDecoration.underline,
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
                          color: Color(0xFF322505), // Foreground
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        gamebook.description,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF9C8B73), // Secondary
                        ),
                      ),
                      SizedBox(height: 16),

                      // Date Section
                      Text(
                        'dates'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF322505), // Foreground
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 18, color: Color(0xFFFA802F)), // Accent
                          SizedBox(width: 8),
                          Text(
                            '${"start_date".tr}: ${gamebook.startDate.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF9C8B73), // Secondary
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      if (gamebook.endDate != null)
                        Row(
                          children: [
                            Icon(Icons.event,
                                size: 18, color: Color(0xFFFA802F)), // Accent
                            SizedBox(width: 8),
                            Text(
                              '${"end_date".tr}: ${gamebook.endDate!.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF9C8B73), // Secondary
                              ),
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
                          color: Color(0xFF322505), // Foreground
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
                              color: Color(0xFFF3E8CA)
                                  .withOpacity(0.6), // Background
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(0xFF9C8B73)
                                      .withOpacity(0.3), // Secondary
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color(0xFFFA802F)
                                      .withOpacity(0.3), // Accent
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        color: Color(0xFF322505), // Foreground
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  step.text,
                                  style: TextStyle(
                                    color: Color(0xFF322505), // Foreground
                                  ),
                                ),
                                subtitle: Text(
                                  'Step ID: ${step.id}',
                                  style: TextStyle(
                                    color: Color(0xFF9C8B73), // Secondary
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      else
                        Text(
                          'No steps available.',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF9C8B73), // Secondary
                              fontStyle: FontStyle.italic),
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
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: authController.isAuthenticated
                                ? () => Get.toNamed(AppRoutes.gameDetail
                                    .replaceFirst(
                                        ":id", gamebook.id.toString()))
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: authController.isAuthenticated
                                  ? Color(0xFFFA802F) // Accent
                                  : Color(0xFF9C8B73)
                                      .withOpacity(0.3), // Secondary
                            ),
                            child: Text(
                              'play_game'.tr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF3E8CA), // Background
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
                            color: Color(0xFF9C8B73), // Secondary
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
                child: Text(
              'No data found.',
              style: TextStyle(color: Color(0xFF9C8B73)), // Secondary
            ));
          }
        },
      ),
    );
  }
}
