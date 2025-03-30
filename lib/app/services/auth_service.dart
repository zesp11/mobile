import 'package:get/get.dart';
import 'package:gotale/app/models/loginResponse.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:gotale/utils/env_config.dart';
import 'package:logger/logger.dart';

class AuthService extends GetxService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  AuthService({required this.apiService});
  // Simulating local data for token
  static const String _mockToken = 'testToken';

  Future<LoginResponse> login(String username, String password) async {
    if (EnvConfig.isDebugProd || EnvConfig.isProduction) {
      Map<String, dynamic> credentials =
          await apiService.login(username, password);

      return LoginResponse(
        userId: credentials['user_id'],
        token: credentials['token'],
        refreshToken: credentials['refresh_token'],
      );
    }

    // INFO: this is only for development GET RID OF IF IN PRODUCTION
    // Simulate checking the username and password locally
    if ((username == '1' && password == '1') ||
        (username == '2' && password == '2') ||
        (username == '3' && password == '3')) {
      // Simulating a successful login by returning the mock token
      return LoginResponse(
        userId: int.parse(username),
        token: _mockToken,
        refreshToken: _mockToken,
      ); // return he's login
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

  Future<void> register(String username, String email, String password) async {
    return apiService.register(username, email, password);
  }
}
