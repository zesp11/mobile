import 'package:get/get.dart';
import 'package:goadventure/app/models/user.dart';
import 'package:goadventure/app/services/user_service.dart';

// TODO: implement that class fully
// currently it only mocks user
class AuthController extends GetxController {
  // To fetch user data after authentication
  final UserService userService;
  // userProfile is null if user is not logged in
  var userProfile = Rx<UserProfile?>(null);
  bool get isAuthenticated => userProfile.value != null;

  AuthController({required this.userService});

  @override
  void onInit() {
    super.onInit();
    // Initialize with checking the current session or auth token
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    // You could check local storage for a token or session,
    // for example jwt token:
    // TODO: use jwt token
    // String? token = await getAuthTokenFromStorage();
    // if (token != null) {
    //   fetchUserProfile();
    // }
  }

  // Fetch user profile for the logged-in user
  Future<void> fetchUserProfile() async {
    try {
      userProfile.value = await userService.fetchCurrentUserProfile();
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // Login method to handle authentication
  Future<void> login(String username, String password) async {
    try {
      // final token = await userService.login(username, password);
      // Store token in local storage
      // await storeAuthToken(token);
      await fetchUserProfile(); // Fetch user profile after login
      print("[AUTH_DEBUG] logged in with userId=${userProfile.value!.id}");
    } catch (e) {
      print('Login failed: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    // Clear stored token and reset user profile
    // await clearAuthToken();
    userProfile.value = null;
    print("[AUTH_DEBUG] logged out");
  }

  // TODO: storage service (storing and retrieving auth token)
  // Future<void> storeAuthToken(String token) async {
  //   final storage = Get.find<FlutterSecureStorage>();
  //   await storage.write(key: 'authToken', value: token);
  // }

  // Future<String?> getAuthTokenFromStorage() async {
  //   final storage = Get.find<FlutterSecureStorage>();
  //   return await storage.read(key: 'authToken');
  // }

  // Future<void> clearAuthToken() async {
  //   final storage = Get.find<FlutterSecureStorage>();
  //   await storage.delete(key: 'authToken');
  // }
}
