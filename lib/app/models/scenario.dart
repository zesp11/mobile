import 'package:gotale/app/models/step.dart';
import 'package:gotale/app/models/user.dart';

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

//   final int id;
//   final String title;
//   final String description; // Overview of the gamebook
//   final DateTime startDate;
//   final DateTime? endDate;
//   final List<Step> steps;
//   final int authorId;

part 'scenario.g.dart';

Scenario scenarioFromJson(String str) => Scenario.fromJson(json.decode(str));

String scenarioToJson(Scenario data) => json.encode(data.toJson());

@JsonSerializable()
class Scenario {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "first_step")
  FirstStep firstStep;
  @JsonKey(name: "author")
  Author author;
  @JsonKey(name: "limit_players")
  int limitPlayers;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "description")
  dynamic description;
  @JsonKey(name: "creation_date")
  DateTime creationDate;
  @JsonKey(name: "id_photo")
  int idPhoto;

  Scenario({
    required this.id,
    required this.firstStep,
    required this.author,
    required this.limitPlayers,
    required this.name,
    required this.description,
    required this.creationDate,
    required this.idPhoto,
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
  String login;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "bio")
  String? bio;
  @JsonKey(name: "creationDate")
  DateTime creationDate;

  Author({
    required this.id,
    required this.login,
    required this.email,
    this.bio,
    required this.creationDate,
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

@JsonSerializable()
class FirstStep {
  @JsonKey(name: "id_step")
  int id;
  @JsonKey(name: "latitude")
  dynamic latitude;
  @JsonKey(name: "text")
  dynamic text;
  @JsonKey(name: "title")
  dynamic title;
  @JsonKey(name: "choices")
  List<dynamic> choices;
  @JsonKey(name: "longitude")
  dynamic longitude;

  FirstStep({
    required this.id,
    required this.latitude,
    required this.text,
    required this.title,
    required this.choices,
    required this.longitude,
  });

  factory FirstStep.fromJson(Map<String, dynamic> json) =>
      _$FirstStepFromJson(json);

  Map<String, dynamic> toJson() => _$FirstStepToJson(this);
}
