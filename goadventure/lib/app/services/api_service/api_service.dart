// Centralized service for interacting with the backend.
// specification for the REST API can be found in rest-api-specification.md
// https://github.com/Serp-ent/zesp11/blob/feature/backend/rest-api-specification/rest_api_specification.md
// WARNING: the link may expire after merge
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

  /* Authentication endpoints */
  // TODO: Future<void> registerUser();
  // TODO: Future<void> login();
  // TODO: Future<void> logout();
  // TODO: Future<void> refreshToken();

  /* User endpoints */
  Future<Map<String, dynamic>> getUserProfile(String id);
  // TODO: Future<void> getCurrentUserProfile();
  // TODO: updateProfile();
  // TODO: getUsersList;
  // TODO: removeAccount;

  /* Scenario endpoints */
  // INFO: the mobile app doesn't allow for scenario creation
  Future<List<Map<String, dynamic>>> getAvailableGamebooks();
  Future<Map<String, dynamic>> getGameBookWithId(int gamebookId);
  // TODO: removeScenario();

  /* Game endpoints */
  // Future<void> createGame();
  // Future<void> getGameWithId(int id);
  // Future<void> getNearbyGames(int id);
  // Future<void> getStep(int id);
  // Future<void> makeStep(int id);

  // Search functionality for players, gamebooks, and cities
  Future<List<dynamic>> search(String query, String category);
}
