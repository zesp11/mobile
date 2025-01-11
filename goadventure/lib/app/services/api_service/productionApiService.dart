import 'package:goadventure/app/services/api_service/api_service.dart';

class ProductionApiService extends ApiService {
  // Authentication endpoints
  static const String registerRoute = '/api/auth/register';
  static const String loginRoute = '/api/auth/login';
  static const String logoutRoute = '/api/auth/logout';
  static const String refreshTokenRoute = '/api/auth/refresh';

  // User endpoints
  static const String getUserProfileRoute = '/api/users/:id';
  static const String getCurrentUserProfileRoute = '/api/users/profile';
  static const String updateProfileRoute = '/api/users/profile';
  static const String getUsersListRoute = '/api/users';
  static const String removeAccountRoute = '/api/users/:id';

  // Scenario endpoints
  static const String getAvailableGamebooksRoute = '/api/scenarios';
  static const String getGameBookWithIdRoute = '/api/scenarios/:id';
  static const String removeScenarioRoute = '/api/scenarios/:id';

  // Game endpoints
  static const String createGameRoute = '/api/games';
  static const String getGameWithIdRoute = '/api/games/:id';
  static const String getNearbyGamesRoute = '/api/games/:id';
  static const String getStepRoute = '/api/games/:id/step';
  static const String makeStepRoute = '/api/games/:id/step';

  /* Authentication endpoints */
  Future<void> registerUser(String username, String email, String password) {
    throw UnimplementedError('registerUser() is not implemented.');
  }

  Future<void> login(String username, String password) {
    throw UnimplementedError('login() is not implemented.');
  }

  Future<void> logout() {
    throw UnimplementedError('logout() is not implemented.');
  }

  Future<void> refreshToken() {
    throw UnimplementedError('refreshToken() is not implemented.');
  }

  /* User endpoints */
  Future<Map<String, dynamic>> getUserProfile(String id) {
    throw UnimplementedError('getUserProfile() is not implemented.');
  }

  Future<Map<String, dynamic>> getCurrentUserProfile() {
    throw UnimplementedError('getCurrentUserProfile() is not implemented.');
  }

  Future<void> updateProfile(Map<String, dynamic> profile) {
    throw UnimplementedError('updateProfile() is not implemented.');
  }

  Future<List<Map<String, dynamic>>> getUsersList() {
    throw UnimplementedError('getUsersList() is not implemented.');
  }

  Future<void> removeAccount(String id) {
    throw UnimplementedError('removeAccount() is not implemented.');
  }

  /* Scenario endpoints */
  Future<List<Map<String, dynamic>>> getAvailableGamebooks() {
    throw UnimplementedError('getAvailableGamebooks() is not implemented.');
  }

  Future<Map<String, dynamic>> getGameBookWithId(int gamebookId) {
    throw UnimplementedError('getGameBookWithId() is not implemented.');
  }

  Future<void> removeScenario(int scenarioId) {
    throw UnimplementedError('removeScenario() is not implemented.');
  }

  /* Game endpoints */
  Future<void> createGame(Map<String, dynamic> gameData) {
    throw UnimplementedError('createGame() is not implemented.');
  }

  Future<Map<String, dynamic>> getGameWithId(int id) {
    throw UnimplementedError('getGameWithId() is not implemented.');
  }

  Future<List<Map<String, dynamic>>> getNearbyGames(int id) {
    throw UnimplementedError('getNearbyGames() is not implemented.');
  }

  Future<Map<String, dynamic>> getStep(int id) {
    throw UnimplementedError('getStep() is not implemented.');
  }

  Future<void> makeStep(int id, String decision) {
    throw UnimplementedError('makeStep() is not implemented.');
  }

  /* Search functionality for players, gamebooks, and cities */
  Future<List<dynamic>> search(String query, String category) {
    throw UnimplementedError('search() is not implemented.');
  }
}
