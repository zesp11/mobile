import 'package:goadventure/app/models/decision.dart';

class Step {
  final int id; // ID of the step
  final String title; // Title of the step
  final String text; // Detailed text for this step
  final double latitude; // Location latitude
  final double longitude; // Location longitude
  final List<Decision> decisions; // Up to 4 decisions leading to next steps

  Step({
    required this.id,
    required this.title,
    required this.text,
    required this.latitude,
    required this.longitude,
    required this.decisions,
  });

  // From JSON constructor
  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      decisions: (json['decisions'] as List)
          .map((decisionJson) => Decision.fromJson(decisionJson))
          .toList(),
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'latitude': latitude,
      'longitude': longitude,
      'decisions': decisions.map((decision) => decision.toJson()).toList(),
    };
  }
}
