import 'package:goadventure/app/services/api_service/api_service.dart';

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});
  // Simulating local data for token
  static const String _mockToken = 'testToken';

  Future<String> login(String username, String password) async {
    // Simulate checking the username and password locally
    if (username == 'testUsername' && password == 'testPassword') {
      // Simulating a successful login by returning the mock token
      return _mockToken;
    } else {
      // Simulate a login failure
      throw Exception('Invalid username or password');
    }
  }

  Future<void> logout() async {
    // Simulate a successful logout
    // You can also mock clearing any stored data here if needed
    print("User logged out successfully");
  }
}
