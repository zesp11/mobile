// To parse this JSON data, do
//
//     final gameCreated = gameCreatedFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:gotale/app/models/game_step.dart';

part 'game_created.g.dart';

GameCreated gameCreatedFromJson(String str) =>
    GameCreated.fromJson(json.decode(str));

String gameCreatedToJson(GameCreated data) => json.encode(data.toJson());

@JsonSerializable()
class GameCreated {
  @JsonKey(name: "user_id")
  int userId;
  @JsonKey(name: "id_ses")
  int idSes;
  @JsonKey(name: "id_author")
  int idAuthor;
  @JsonKey(name: "id_game")
  int idGame;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "photo_url")
  String? photoUrl;
  @JsonKey(name: "first_step")
  GameStep firstStep;

  GameCreated({
    required this.userId,
    required this.idSes,
    required this.idAuthor,
    required this.idGame,
    required this.name,
    this.photoUrl,
    required this.firstStep,
  });

  factory GameCreated.fromJson(Map<String, dynamic> json) =>
      _$GameCreatedFromJson(json);

  Map<String, dynamic> toJson() => _$GameCreatedToJson(this);
}
