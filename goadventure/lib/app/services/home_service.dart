import 'package:get/get.dart';
import 'package:goadventure/app/models/decision.dart';
import 'package:goadventure/app/models/gamebook.dart';
import 'package:goadventure/app/models/step.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';

class HomeService extends GetxService {
  final ApiService apiService;

  // Constructor for dependency injection
  HomeService({required this.apiService});

  // Method to fetch nearby games, returning a list of Gamebook objects
  Future<List<Gamebook>> fetchNearbyGames() async {
    try {
      // Simulating location; you can replace this with the actual location
      Map<String, double> location = {'lat': 37.7749, 'lon': -122.4194};
      List<dynamic> gamebooksData =
          await apiService.getNearbyGamebooks(location);

      // Convert fetched data into Gamebook objects
      return gamebooksData.map((data) {
        List<Step> steps = (data['steps'] as List<dynamic>).map((stepData) {
          List<Decision> decisions =
              (stepData['decisions'] as List<dynamic>).map((decisionData) {
            return Decision(
              text: decisionData['text'],
              action: decisionData['action'],
            );
          }).toList();

          return Step(
            name: stepData['name'],
            nextItem: stepData['nextItem'],
            decisions: decisions,
          );
        }).toList();

        return Gamebook(
          name: data['name'],
          title: data['title'],
          startDate: DateTime.parse(data['startDate']),
          endDate:
              data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
          steps: steps,
        );
      }).toList();
    } catch (e) {
      print('Error fetching nearby games: $e');
      return []; // Return an empty list on error
    }
  }

  // Method to fetch last game details
  Future<Gamebook?> fetchLastGame() async {
    try {
      List<dynamic> resumeGames = await apiService.getResumeGames();
      if (resumeGames.isNotEmpty) {
        var data = resumeGames[0];

        // Add null checks or default values for fields
        String name = data['name'] ?? 'Unnamed Game';
        String title = data['title'] ?? 'Untitled';
        DateTime startDate =
            DateTime.tryParse(data['startDate'] ?? '') ?? DateTime.now();
        DateTime? endDate = data['endDate'] != null
            ? DateTime.tryParse(data['endDate']!)
            : null;

        List<Step> steps = (data['steps'] as List<dynamic>).map((stepData) {
          List<Decision> decisions =
              (stepData['decisions'] as List<dynamic>).map((decisionData) {
            return Decision(
              text: decisionData['text'] ?? '',
              action: decisionData['action'] ?? '',
            );
          }).toList();

          return Step(
            name: stepData['name'] ?? 'Unnamed Step',
            nextItem: stepData['nextItem'] ?? '',
            decisions: decisions,
          );
        }).toList();

        return Gamebook(
          name: name,
          title: title,
          startDate: startDate,
          endDate: endDate,
          steps: steps,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching last game: $e');
      return null;
    }
  }
}
