// TODO: adjust the models
import 'package:goadventure/app/models/step.dart';

class Gamebook {
  final String name;
  final String title;
  final DateTime startDate;
  final DateTime? endDate; // Nullable as the game might still be ongoing
  final List<Step> steps;

  Gamebook({
    required this.name,
    required this.title,
    required this.startDate,
    this.endDate,
    required this.steps,
  });
}
