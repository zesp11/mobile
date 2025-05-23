import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/models/user.dart';

class SearchResult {
  List<User> users;
  List<Scenario> scenarios;
  List<Lobby> lobbies;

  SearchResult(
      {required this.users, required this.scenarios, required this.lobbies});

  int get length {
    return users.length + scenarios.length + lobbies.length;
  }

  bool get isEmpty {
    return users.isEmpty && scenarios.isEmpty && lobbies.isEmpty;
  }
}
