class LobbyLight {
  final int idLobby;
  final String status;
  final DateTime creationDate;
  final int idHost;
  final int idScen;
  final int idSession;
  final int idGame;

  LobbyLight({
    required this.idLobby,
    required this.status,
    required this.creationDate,
    required this.idHost,
    required this.idScen,
    required this.idGame,
    required this.idSession,
  });

  factory LobbyLight.fromJson(Map<String, dynamic> json) {
    return LobbyLight(
      idLobby: json['id_lobby'] ?? 0,
      status: json['status'] ?? 'Unknown',
      creationDate: DateTime.parse(json['creation_date']),
      idHost: json['id_host'] ?? 0,
      idScen: json['id_scen'] ?? 0,
      idGame: json['id_game'] ?? 0,
      idSession: json['id_ses'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_lobby': idLobby,
      'status': status,
      'creation_date': creationDate.toIso8601String(),
      'id_host': idHost,
      'id_scen': idScen,
      'id_game': idGame,
      'id_ses': idSession,
    };
  }
}