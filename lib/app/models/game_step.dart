// To parse this JSON data, do
//
//     final gameStep = gameStepFromJson(jsonString);

import 'package:gotale/app/models/choice.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'game_step.g.dart';

GameStep gameStepFromJson(String str) => GameStep.fromJson(json.decode(str));

String gameStepToJson(GameStep data) => json.encode(data.toJson());

@JsonSerializable()
class GameStep {
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "text")
  String? text;
  @JsonKey(name: "longitude")
  double? longitude;
  @JsonKey(name: "latitude")
  double? latitude;
  @JsonKey(name: "photoUrl")
  String? photoUrl;
  @JsonKey(name: "choices")
  List<Choice> choices;
  @JsonKey(name: "id_step")
  int id;

  GameStep({
    this.title,
    this.text,
    this.longitude,
    this.latitude,
    this.photoUrl,
    required this.choices,
    required this.id,
  });

  factory GameStep.fromJson(Map<String, dynamic> json) =>
      _$GameStepFromJson(json);

  Map<String, dynamic> toJson() => _$GameStepToJson(this);
}
