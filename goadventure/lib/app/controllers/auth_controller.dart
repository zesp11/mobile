import 'package:get/get.dart';
import 'package:goadventure/app/models/user.dart';
import 'package:goadventure/app/services/auth_service.dart';
import 'package:goadventure/app/services/user_service.dart';
import 'package:logger/logger.dart';

// TODO: implement that class fully
// currently it only mocks user
class AuthController extends GetxController with StateMixin<UserProfile> {
  // To fetch user data after authentication
  final UserService userService;
  final AuthService authService;
  final logger = Get.find<Logger>();
  // userProfile is null if user is not logged in
  bool get isAuthenticated => state != null;

  AuthController({required this.userService, required this.authService});

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  /// Check the current authentication status (e.g., session or token validity)
  Future<void> checkAuthStatus() async {
    // try {
    logger.i("Checking authentication status...");
    change(null, status: RxStatus.loading());

    //   // Example: Fetch the token from secure storage
    //   final token = await _getAuthTokenFromStorage();

    //   if (token != null) {
    //     await fetchUserProfile(); // Fetch the user profile if token exists
    //   } else {
    logger.i("No valid authentication token found.");
    change(null, status: RxStatus.empty());
    //   }
    // } catch (e) {
    //   logger.e("Error checking authentication status: $e");
    //   change(null,
    //       status: RxStatus.error("Failed to check authentication status."));
    // }
  }

  /// Fetch the user profile for the logged-in user
  Future<void> fetchUserProfile() async {
    try {
      change(null, status: RxStatus.loading());
      final user = await userService.fetchCurrentUserProfile();
      logger.i("[AUTH_DEBUG] User profile fetched: ${user.id}");
      change(user, status: RxStatus.success());
    } catch (e) {
      logger.e("Error fetching user profile: $e");
      change(null, status: RxStatus.error("Failed to fetch user profile."));
    }
  }

  /// Login method to handle user authentication
  Future<void> login(String username, String password) async {
    try {
      change(null, status: RxStatus.loading());
      await authService.login(username, password);
      await fetchUserProfile();
      logger.i("[AUTH_DEBUG] Logged in successfully");
    } catch (e) {
      logger.e("Login failed: $e");
      change(null, status: RxStatus.error("Invalid username or password."));
    }
  }

  /// Logout method to clear user session
  Future<void> logout() async {
    try {
      change(null, status: RxStatus.loading());
      await _clearAuthToken();
      await authService.logout();
      change(null, status: RxStatus.empty());
      logger.i("[AUTH_DEBUG] Logged out successfully");
    } catch (e) {
      logger.e("Logout failed: $e");
      change(null, status: RxStatus.error("Failed to log out."));
    }
  }

  /// Private helper to retrieve auth token from storage
  Future<String?> _getAuthTokenFromStorage() async {
    // TODO: Implement secure storage logic to get token
    // throw UnimplementedError();
    return null; // Replace with actual logic
  }

  /// Private helper to clear auth token from storage
  Future<void> _clearAuthToken() async {
    // TODO: Implement secure storage logic to clear token
    // throw UnimplementedError();
  }
}
