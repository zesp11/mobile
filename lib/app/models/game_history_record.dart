import 'package:gotale/app/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'game_history_record.g.dart';

List<GameHistoryRecord> gameHistoryRecordFromJson(String str) =>
    List<GameHistoryRecord>.from(
        json.decode(str).map((x) => GameHistoryRecord.fromJson(x)));

String gameHistoryRecordToJson(List<GameHistoryRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class GameHistoryRecord {
  @JsonKey(name: "end_date")
  DateTime? endDate;
  @JsonKey(name: "previous_step")
  PreviousStep? previousStep;
  @JsonKey(name: "id_game")
  int idGame;
  @JsonKey(name: "user")
  User user;
  @JsonKey(name: "start_date")
  DateTime startDate;
  @JsonKey(name: "choice")
  GameHistoryChoice? choice;
  @JsonKey(name: "current_step")
  CurrentStep currentStep;

  GameHistoryRecord({
    this.endDate,
    this.previousStep,
    required this.idGame,
    required this.user,
    required this.currentStep,
    required this.startDate,
    this.choice,
  });

  factory GameHistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$GameHistoryRecordFromJson(json);

  Map<String, dynamic> toJson() => _$GameHistoryRecordToJson(this);
}

@JsonSerializable()
class GameHistoryChoice {
  @JsonKey(name: "id_choice")
  int idChoice;
  @JsonKey(name: "text")
  String text;

  GameHistoryChoice({
    required this.idChoice,
    required this.text,
  });

  factory GameHistoryChoice.fromJson(Map<String, dynamic> json) =>
      _$GameHistoryChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$GameHistoryChoiceToJson(this);
}

// Sorry, backend returns all the time models with different names
// and additionally those names have different string key...
@JsonSerializable()
class CurrentStep {
  @JsonKey(name: "latitude")
  double latitude;
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "photo_url")
  String photoUrl;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "longitude")
  double longitude;

  CurrentStep({
    required this.latitude,
    required this.id,
    required this.text,
    required this.photoUrl,
    required this.title,
    required this.longitude,
  });

  factory CurrentStep.fromJson(Map<String, dynamic> json) =>
      _$CurrentStepFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentStepToJson(this);
}

@JsonSerializable()
class PreviousStep {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "title")
  String title;

  PreviousStep({
    required this.id,
    required this.text,
    required this.title,
  });

  factory PreviousStep.fromJson(Map<String, dynamic> json) =>
      _$PreviousStepFromJson(json);

  Map<String, dynamic> toJson() => _$PreviousStepToJson(this);
}
