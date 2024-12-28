import 'package:goadventure/app/models/decision.dart';

class Step {
  final String name;
  final String nextItem; // The next item to be fetched or action to be taken
  final List<Decision> decisions; // up 4 decisions

  Step({required this.name, required this.nextItem, required this.decisions});
}
