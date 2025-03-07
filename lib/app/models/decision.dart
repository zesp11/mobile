// TODO: read if each model should contain id field for primary key
class Decision {
  final String text; // Text describing the choice
  final int nextStepId; // The ID of the next step, not the step itself

  Decision({
    required this.text,
    required this.nextStepId,
  });

  // From JSON constructor
  factory Decision.fromJson(Map<String, dynamic> json) {
    return Decision(
      text: json['text'],
      nextStepId: json['nextStepId'], // Use nextStepId instead of nextStep
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'nextStepId': nextStepId, // Store nextStepId, not nextStep
    };
  }
}
