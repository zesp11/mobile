import 'package:gotale/app/models/step.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'created_game.g.dart';

CreatedGame createdGameFromJson(String str) =>
    CreatedGame.fromJson(json.decode(str));

String createdGameToJson(CreatedGame data) => json.encode(data.toJson());

@JsonSerializable()
class CreatedGame {
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
  @JsonKey(name: "first_step")
  Step firstStep;

  CreatedGame({
    required this.userId,
    required this.idSes,
    required this.idAuthor,
    required this.idGame,
    required this.name,
    required this.firstStep,
  });

  factory CreatedGame.fromJson(Map<String, dynamic> json) =>
      _$CreatedGameFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedGameToJson(this);
}
