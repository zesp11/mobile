// To parse this JSON data, do
//
//     final gameHistoryRecord = gameHistoryRecordFromJson(jsonString);

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
  @JsonKey(name: "previous_step_text")
  String? previousStepText;
  @JsonKey(name: "id_ses")
  int idSes;
  @JsonKey(name: "id_user")
  int idUser;
  @JsonKey(name: "id_game")
  int idGame;
  @JsonKey(name: "current_step")
  int currentStep;
  @JsonKey(name: "start_date")
  DateTime startDate;
  @JsonKey(name: "choice_text")
  String? choiceText;

  GameHistoryRecord({
    required this.endDate,
    required this.previousStepText,
    required this.idSes,
    required this.idUser,
    required this.idGame,
    required this.currentStep,
    required this.startDate,
    this.choiceText,
  });

  factory GameHistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$GameHistoryRecordFromJson(json);

  Map<String, dynamic> toJson() => _$GameHistoryRecordToJson(this);
}
