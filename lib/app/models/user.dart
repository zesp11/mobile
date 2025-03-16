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

  User({
    required this.id,
    required this.login,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
