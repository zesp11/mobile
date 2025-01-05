import 'package:get/get.dart';
import 'package:goadventure/app/models/decision.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/models/step.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:logger/logger.dart';

class HomeService extends GetxService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  // Constructor for dependency injection
  HomeService({required this.apiService});

  /// Method to fetch nearby games
  Future<List<Gamebook>> fetchNearbyGames() async {
    try {
      // Simulated location; replace with actual user location if available
      Map<String, double> location = {'lat': 37.7749, 'lon': -122.4194};
      List<dynamic> gamebooksData =
          await apiService.getNearbyGamebooks(location);

      // Parse and map the fetched data into Gamebook objects
      return gamebooksData.map((data) {
        List<Step> steps = (data['steps'] as List<dynamic>?)?.map((stepData) {
              List<Decision> decisions =
                  (stepData['decisions'] as List<dynamic>?)
                          ?.map((decisionData) {
                        // Ensure required parameters are correctly passed
                        var nextStep = Step(
                          id: decisionData['nextStepId'] ??
                              0, // Provide default if missing
                          title: decisionData['nextStepTitle'] ?? 'Next Step',
                          text: decisionData['nextStepText'] ??
                              'Description of next step',
                          latitude: decisionData['nextStepLatitude'] ?? 0.0,
                          longitude: decisionData['nextStepLongitude'] ?? 0.0,
                          decisions: [], // Assuming decisions are fetched separately
                        );

                        return Decision(
                          text: decisionData['text'] ?? 'No decision text',
                          nextStepId: nextStep.id,
                        );
                      }).toList() ??
                      [];

              return Step(
                id: stepData['id'] ?? 0, // Ensure step ID is provided
                title: stepData['title'] ?? 'Unnamed Step',
                text: stepData['text'] ??
                    'No description provided', // Step text added
                latitude:
                    stepData['latitude'] ?? 0.0, // Ensure latitude is provided
                longitude: stepData['longitude'] ??
                    0.0, // Ensure longitude is provided
                decisions: decisions,
              );
            }).toList() ??
            [];

        return Gamebook(
          id: data['id'],
          name: data['name'] ?? 'Unnamed Game',
          title: data['title'] ?? 'Untitled',
          description: data['description'] ??
              'No description provided', // Added description
          startDate: DateTime.tryParse(data['startDate'] ?? '') ??
              DateTime.now(), // Default to current time
          endDate: data['endDate'] != null
              ? DateTime.tryParse(data['endDate']!)
              : null,
          steps: steps,
          authorId: data['authorId'],
        );
      }).toList();
    } catch (e) {
      logger.e('Error fetching nearby games: $e');
      return [];
    }
  }

  /// Method to fetch the last game played
  Future<Gamebook?> fetchLastGame() async {
    try {
      List<dynamic> resumeGames = await apiService.getResumeGames();

      if (resumeGames.isNotEmpty) {
        var data = resumeGames[0];

        // Parse steps and decisions
        List<Step> steps = (data['steps'] as List<dynamic>?)?.map((stepData) {
              List<Decision> decisions =
                  (stepData['decisions'] as List<dynamic>?)
                          ?.map((decisionData) {
                        var nextStep = Step(
                          id: decisionData['nextStepId'] ??
                              0, // Default for next step
                          title: decisionData['nextStepTitle'] ?? 'Next Step',
                          text: decisionData['nextStepText'] ??
                              'Description of next step',
                          latitude: decisionData['nextStepLatitude'] ?? 0.0,
                          longitude: decisionData['nextStepLongitude'] ?? 0.0,
                          decisions: [], // Assuming decisions are fetched separately
                        );

                        return Decision(
                          text: decisionData['text'] ?? 'No decision text',
                          nextStepId: nextStep.id,
                        );
                      }).toList() ??
                      [];

              return Step(
                id: stepData['id'] ?? 0,
                title: stepData['title'] ?? 'Unnamed Step',
                text: stepData['text'] ??
                    'No description provided', // Step text added
                latitude: stepData['latitude'] ?? 0.0,
                longitude: stepData['longitude'] ?? 0.0,
                decisions: decisions,
              );
            }).toList() ??
            [];

        return Gamebook(
          id: data['id'],
          name: data['name'] ?? 'Unnamed Game',
          title: data['title'] ?? 'Untitled',
          description: data['description'] ??
              'No description provided', // Added description
          startDate:
              DateTime.tryParse(data['startDate'] ?? '') ?? DateTime.now(),
          endDate: data['endDate'] != null
              ? DateTime.tryParse(data['endDate']!)
              : null,
          steps: steps,
          authorId: data['authorId'],
        );
      }
      return null; // No games to resume
    } catch (e) {
      logger.e('Error fetching last game: $e');
      return null;
    }
  }
}
