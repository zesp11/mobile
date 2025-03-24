// TODO:
// final String id;
// String name;
// String email;
// String avatar;
// String bio;
// final int gamesPlayed;
// final int gamesFinished;
// final Map<String, dynamic> preferences;
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user.g.dart';

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String usersToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

@JsonSerializable()
class User {
  @JsonKey(name: "id_user")
  int id;
  @JsonKey(name: "login")
  String login;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "bio")
  String? bio;
  @JsonKey(name: "creation_date")
  DateTime creationDate;
  @JsonKey(name: "photo_url")
  String? photoUrl;

  User({
    required this.id,
    required this.login,
    required this.email,
    required this.bio,
    required this.creationDate,
    required this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
