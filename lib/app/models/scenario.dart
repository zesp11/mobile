// To parse this JSON data, do
//
//     final scenario = scenarioFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'scenario.g.dart';

List<Scenario> scenarioFromJson(String str) =>
    List<Scenario>.from(json.decode(str).map((x) => Scenario.fromJson(x)));

String scenarioToJson(List<Scenario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Scenario {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "author")
  Author author;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "limit_players")
  int limitPlayers;
  @JsonKey(name: "creation_date")
  DateTime creationDate;
  @JsonKey(name: "photo_url")
  String? photoUrl;

  Scenario({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
    required this.limitPlayers,
    required this.creationDate,
    required this.photoUrl,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);

  Map<String, dynamic> toJson() => _$ScenarioToJson(this);
}

@JsonSerializable()
class Author {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "login")
  String? login;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "bio")
  String? bio;
  @JsonKey(name: "creation_date")
  DateTime creationDate;
  @JsonKey(name: "photo_url")
  String? photoUrl;

  Author({
    required this.id,
    required this.login,
    required this.email,
    required this.bio,
    required this.creationDate,
    required this.photoUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
