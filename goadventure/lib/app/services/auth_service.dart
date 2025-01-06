import 'package:get/get.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';
import 'package:goadventure/main.dart';
import 'package:logger/logger.dart';

class AuthService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  AuthService({required this.apiService});
  // Simulating local data for token
  static const String _mockToken = 'testToken';

  Future<String> login(String username, String password) async {
    if (isProduction) {
      logger.f("AuthService is not implemented in production");
      UnimplementedError();
    }

    // INFO: this is only for development GET RID OF IF IN PRODUCTION
    // Simulate checking the username and password locally
    if ((username == '1' && password == '1') ||
        (username == '2' && password == '2') ||
        (username == '3' && password == '3')) {
      // Simulating a successful login by returning the mock token
      return username; // return he's login
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
