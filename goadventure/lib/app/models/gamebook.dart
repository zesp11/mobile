// TODO: adjust the models
import 'package:goadventure/app/models/step.dart';

class Gamebook {
  // TODO: consider if id's shouldn't be string anyway UUID? can check for number etc...
  final int id;
  final String name;
  final String title;
  final String description; // Overview of the gamebook
  final DateTime startDate;
  final DateTime? endDate;
  final List<Step> steps;
  final int authorId;

  Gamebook({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.steps,
    required this.authorId,
  });

  // From JSON constructor
  factory Gamebook.fromJson(Map<String, dynamic> json) {
    final game = Gamebook(
      id: json['id'] ?? 0, // default to 0 if id is null
      name: json['name'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      steps: (json['steps'] as List)
          .map((stepJson) => Step.fromJson(stepJson))
          .toList(),
      authorId: json['authorId'] ?? 0, // default to 0 if id is null
    );

    return game;
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'steps': steps.map((step) => step.toJson()).toList(),
      'authorId': authorId,
    };
  }
}
