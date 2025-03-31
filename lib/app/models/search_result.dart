import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/models/user.dart';

class SearchResult {
  List<User> users;
  List<Scenario> scenarios;

  SearchResult({required this.users, required this.scenarios});

  int get length {
    return users.length + scenarios.length;
  }

  bool get isEmpty {
    return users.isEmpty && scenarios.isEmpty;
  }
}
