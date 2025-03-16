// Centralized service for interacting with the backend.
// specification for the REST API can be found in rest-api-specification.md
// https://github.com/Serp-ent/zesp11/blob/feature/backend/rest-api-specification/rest_api_specification.md
// WARNING: the link may expire after merge
import 'package:gotale/app/models/game.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/models/user.dart';

abstract class ApiService {
  /* (TODO: reconsider those endpoints)
  Fetch games that can be resumed
  Future<List<dynamic>> getResumeGames() async

  Fetch new gamebooks
  Future<List<dynamic>> getNewGamebooks() async

  Fetch nearby gamebooks based on user location
  Future<List<dynamic>> getNearbyGamebooks(Map<String, double> location) async

  Fetch details of a specific game
  Future<Map<String, dynamic>> getGameDetails(String gameId);

  Submit a decision for a game
  Future<void> submitDecision(String gameId, String decision);

  Check the decision status for the current game
  Future<String> getDecisionStatus(String gameId);

  Update user profile details
  Future<void> updateUserProfile(Map<String, dynamic> profile);
  */

  /** RESPONSE for successful registration status_code == 201
   * {
    "message": "User registered successfully.",
    "user": {
        "id_user": 26,
        "login": "Kamil2025_081",
        "email": "kamil20205_081@example.com"
    }
}

 Response for failed registration  status_code == 400
{
    "message": "User with this login already exists.",
    "user": null
}
   */

  /* Authentication endpoints */
  Future<void> register(String name, String email, String password);
  Future<Map<String, dynamic>> login(String username, String password);
  // TODO: Future<void> logout();
  // TODO: Future<void> refreshToken();

  /* User endpoints */
  Future<User> getUserProfile(String id);
  Future<List<dynamic>> searchUsers(String query);
  Future<Map<String, dynamic>> getCurrentUserProfile();
  Future<void> updateUserProfile(Map<String, dynamic> profile);
  // TODO: getUsersList;
  // TODO: removeAccount;

  /* Scenario endpoints */
  // INFO: the mobile app doesn't allow for scenario creation
  Future<List<Scenario>> getAvailableGamebooks();
  Future<Scenario> getScenarioWithId(int gamebookId);
  Future<List<dynamic>> searchScenarios(String query);
  Future<Map<String, dynamic>> createGameFromScenario(int scenarioId);
  // TODO: removeScenario();

  /* Game endpoints */
  // Future<void> createGame();
  // Future<void> getGameWithId(int id);
  // Future<void> getNearbyGames(int id);
  Future<Map<String, dynamic>> getCurrentStep(int gameId);
  Future<Map<String, dynamic>> getGamePlay(int gameId);
  Future<List<Game>> getGamesInProgress();
  Future<List<Map<String, dynamic>>> getGameHistory(int gameId);
  Future<Map<String, dynamic>> makeDecision(int gameId, int choiceId);
  // Future<void> getStep(int id);
  // Future<void> makeStep(int id);

  // Search functionality for players, gamebooks, and cities
  Future<List<dynamic>> search(String query, String category);
}
