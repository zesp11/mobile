import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'scenario.dart';

import 'user.dart';
import 'scenario.dart';

class Lobby {
  final int idLobby;
  final String status;
  final DateTime creationDate;
  final User user;
  final Scenario scenario;

  Lobby({
    required this.idLobby,
    required this.status,
    required this.creationDate,
    required this.user,
    required this.scenario,
  });

  factory Lobby.fromJson(Map<String, dynamic> json) {
    return Lobby(
      idLobby: json['id_lobby'] ?? 0,
      status: json['status'] ?? 'Unknown',
      creationDate: DateTime.parse(json['creation_date']),
      user: User.fromJson(json['user']),
      scenario: Scenario.fromJson(json['scenario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_lobby': idLobby,
      'status': status,
      'creation_date': creationDate.toIso8601String(),
      'user': user.toJson(),
      'scenario': scenario.toJson(),
    };
  }
}
