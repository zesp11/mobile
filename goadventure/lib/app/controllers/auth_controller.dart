import 'package:get/get.dart';
import 'package:goadventure/app/models/user.dart';
import 'package:goadventure/app/services/auth_service.dart';
import 'package:goadventure/app/services/user_service.dart';
import 'package:goadventure/main.dart';
import 'package:logger/logger.dart';

// TODO: implement that class fully
// currently it only mocks user
class AuthController extends GetxController with StateMixin<UserProfile> {
  final UserService userService;
  final AuthService authService;
  final logger = Get.find<Logger>();

  bool get isAuthenticated => state != null;

  AuthController({required this.userService, required this.authService});

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  // Step 1: Check if there's a token and determine if the user is logged in
  Future<void> checkAuthStatus() async {
    try {
      logger.i("Checking authentication status...");

      // Step 1a: Try fetching the token from secure storage
      final token = await _getAuthTokenFromStorage();

      if (token != null) {
        // Step 1b: If token exists, decode it and fetch the user profile
        final userId = _decodeTokenAndGetUserId(token);
        if (userId != null) {
          logger.i("Token found, fetching user profile for userId: $userId");
          await _fetchUserProfile(userId);
        } else {
          logger.e("Failed to decode token or extract user ID.");
          change(null, status: RxStatus.error("Invalid token."));
        }
      } else {
        // Step 1c: If no token, set state to empty (logged out)
        logger.i("No valid authentication token found.");
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      logger.e("Error checking authentication status: $e");
      change(null,
          status: RxStatus.error("Failed to check authentication status."));
    }
  }

  // Step 2: Fetch the user profile for the logged-in user using the decoded userId
  Future<void> _fetchUserProfile(String userId) async {
    try {
      change(null, status: RxStatus.loading());
      final user =
          await userService.fetchUserProfile(userId); // Pass the decoded userId
      logger.i("[AUTH_DEBUG] User profile fetched: ${user.id}");
      change(user, status: RxStatus.success());
    } catch (e) {
      logger.e("Error fetching user profile: $e");
      change(null, status: RxStatus.error("Failed to fetch user profile."));
    }
  }

  // Step 3: Login method to authenticate user and fetch user profile
  Future<void> login(String username, String password) async {
    try {
      change(null, status: RxStatus.loading());

      // Step 3a: Call the authentication service
      final response = await authService.login(username, password);

      if (response.isNotEmpty) {
        // Step 3b: On successful login, store the token
        await _storeAuthToken(response);

        // Step 3c: Decode the token to get the userId and fetch the profile
        final userId = _decodeTokenAndGetUserId(response);
        if (userId != null) {
          await _fetchUserProfile(userId);
        } else {
          logger.e("Failed to decode token or extract user ID.");
          change(null, status: RxStatus.error("Invalid token."));
        }

        logger.i("[AUTH_DEBUG] Logged in successfully");
      } else {
        logger.e("Login failed: Invalid response");
        change(null, status: RxStatus.error("Invalid username or password."));
      }
    } catch (e) {
      logger.e("Login failed: $e");
      change(null, status: RxStatus.error("Invalid username or password."));
    }
  }

  // Step 4: Logout method to clear user session
  Future<void> logout() async {
    try {
      change(null, status: RxStatus.loading());

      // Step 4a: Clear stored token
      await _clearAuthToken();

      // Step 4b: Call logout service (this might not be needed in some cases)
      await authService.logout();

      // Step 4c: Set state to empty (logged out)
      change(null, status: RxStatus.empty());
      logger.i("[AUTH_DEBUG] Logged out successfully");
    } catch (e) {
      logger.e("Logout failed: $e");
      change(null, status: RxStatus.error("Failed to log out."));
    }
  }

  // Step 5: Private helper to retrieve auth token from secure storage
  Future<String?> _getAuthTokenFromStorage() async {
    // TODO: Implement secure storage logic to get token
    return null; // Replace with actual logic
  }

  // Step 6: Private helper to store the auth token
  Future<void> _storeAuthToken(String token) async {
    // TODO: Implement secure storage logic to store token
  }

  // Step 7: Private helper to clear the auth token
  Future<void> _clearAuthToken() async {
    // TODO: Implement secure storage logic to clear token
  }

  // Helper function to decode the JWT token and extract the user ID
  String? _decodeTokenAndGetUserId(String token) {
    try {
      if (!isProduction) {
        if (['1', '2', '3'].contains(token)) {
          return token;
        }

        logger.f("Wrong token in development?!");
        throw UnimplementedError();
      } else {
        logger.f("Production doesn't handle the JWT token YET");
        throw UnimplementedError();
        // final jwt = JWT.verify(token,
        //     SecretKey('your_secret_key')); // Use the appropriate key to verify
        // return jwt.payload[
        //     'userId']; // Assuming the userId is stored in the token payload
      }
    } catch (e) {
      logger.e("Failed to decode token: $e");
      return null;
    }
  }
}
