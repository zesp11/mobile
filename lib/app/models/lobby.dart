class Lobby {
  final int idLobby;
  final String status;
  final DateTime creationDate;
  final int userId;
  final int idSes;
  final int idAuthor;
  final int idGame;
  final String name;
  final String photoUrl;
  final StepData firstStep;

  Lobby({
    required this.idLobby,
    required this.status,
    required this.creationDate,
    required this.userId,
    required this.idSes,
    required this.idAuthor,
    required this.idGame,
    required this.name,
    required this.photoUrl,
    required this.firstStep,
  });

  factory Lobby.fromJson(Map<String, dynamic> json) {
    return Lobby(
      idLobby: json['id_lobby'],
      status: json['status'],
      creationDate: DateTime.parse(json['creation_date']),
      userId: json['user_id'],
      idSes: json['id_ses'],
      idAuthor: json['id_author'],
      idGame: json['id_game'],
      name: json['name'],
      photoUrl: json['photo_url'],
      firstStep: StepData.fromJson(json['first_step']),
    );
  }
}

class StepData {
  final int idStep;
  final double latitude;
  final double longitude;
  final String text;
  final String photoUrl;
  final String title;
  final List<Choice> choices;

  StepData({
    required this.idStep,
    required this.latitude,
    required this.longitude,
    required this.text,
    required this.photoUrl,
    required this.title,
    required this.choices,
  });

  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
      idStep: json['id_step'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      text: json['text'],
      photoUrl: json['photo_url'],
      title: json['title'],
      choices: (json['choices'] as List)
          .map((choiceJson) => Choice.fromJson(choiceJson))
          .toList(),
    );
  }
}

class Choice {
  final int idChoice;
  final int idNextStep;
  final String choiceText;

  Choice({
    required this.idChoice,
    required this.idNextStep,
    required this.choiceText,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      idChoice: json['id_choice'],
      idNextStep: json['id_next_step'],
      choiceText: json['choice_text'],
    );
  }
}