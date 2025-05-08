// To parse this JSON data, do
//
//     final gameInProgress = gameInProgressFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'game_in_progress.g.dart';

GameInProgress gameInProgressFromJson(String str) =>
    GameInProgress.fromJson(json.decode(str));

String gameInProgressToJson(GameInProgress data) => json.encode(data.toJson());

List<GameInProgress> gameInProgressListFromJson(String str) =>
    List<GameInProgress>.from(
        json.decode(str).map((x) => GameInProgress.fromJson(x)));

String gameInProgressListToJson(List<GameInProgress> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class GameInProgress {
  @JsonKey(name: "start_time")
  DateTime startTime;
  @JsonKey(name: "end_time")
  DateTime? endTime;
  @JsonKey(name: "scenario_name")
  String scenarioName;
  @JsonKey(name: "id_game")
  int idGame;
  @JsonKey(name: "id_scen")
  int idScen;
  @JsonKey(name: "current_step")
  CurrentStep currentStep;

  GameInProgress({
    required this.startTime,
    required this.endTime,
    required this.scenarioName,
    required this.idGame,
    required this.idScen,
    required this.currentStep,
  });

  factory GameInProgress.fromJson(Map<String, dynamic> json) =>
      _$GameInProgressFromJson(json);

  Map<String, dynamic> toJson() => _$GameInProgressToJson(this);
}

@JsonSerializable()
class CurrentStep {
  @JsonKey(name: "latitude")
  double latitude;
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "longitude")
  double longitude;

  CurrentStep({
    required this.latitude,
    required this.id,
    required this.text,
    required this.title,
    required this.longitude,
  });

  factory CurrentStep.fromJson(Map<String, dynamic> json) =>
      _$CurrentStepFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentStepToJson(this);
}
