import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'game.g.dart';

Game gameFromJson(String str) => Game.fromJson(json.decode(str));

List<Game> gameListFromJson(String str) =>
    List<Game>.from(json.decode(str).map((x) => Game.fromJson(x)));

String gameListToJson(List<Game> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Game {
  @JsonKey(name: "start_time")
  DateTime startTime;
  @JsonKey(name: "current_step_text")
  String currentStepText;
  @JsonKey(name: "end_time")
  DateTime? endTime;
  @JsonKey(name: "scenario_name")
  String scenarioName;
  @JsonKey(name: "id_game")
  int idGame;
  @JsonKey(name: "id_scen")
  int idScen;
  @JsonKey(name: "current_step")
  int currentStep;

  Game({
    required this.startTime,
    required this.currentStepText,
    this.endTime,
    required this.scenarioName,
    required this.idGame,
    required this.idScen,
    required this.currentStep,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);
}
