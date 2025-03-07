import 'dart:convert';

import 'package:get/get.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/services/auth_service.dart';
import 'package:gotale/app/services/user_service.dart';
import 'package:gotale/utils/env_config.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

// TODO: implement that class fully
// currently it only mocks user
class AuthController extends GetxController with StateMixin<UserProfile> {
  final UserService userService;
  final AuthService authService;
  final FlutterSecureStorage secureStorage = Get.find<FlutterSecureStorage>();
  final logger = Get.find<Logger>();

  bool get isAuthenticated => state != null;

  AuthController({required this.userService, required this.authService});

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      logger.i("Checking authentication status...");
      final token = await _getAuthTokenFromStorage();

      if (token != null) {
        final userId = await _decodeTokenAndGetUserId(token);
        if (userId != null) {
          logger.i("Token found, fetching user profile for userId: $userId");
          await _fetchUserProfile(userId);
        } else {
          logger.e("Failed to decode token or extract user ID.");
          await _clearAuthToken();
          change(null, status: RxStatus.error("Invalid token."));
        }
      } else {
        logger.i("No valid authentication token found.");
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      logger.e("Error checking authentication status: $e");
      change(null,
          status:
              RxStatus.error("Authentication check failed ${e.toString()}"));
    }
  }

  Future<void> _fetchUserProfile(String userId) async {
    try {
      change(null, status: RxStatus.loading());
      logger.d('fetching user profile for id=${userId}');
      final user = await userService.fetchUserProfile(userId);
      logger.i("[AUTH_DEBUG] User profile fetched: ${user.id}");
      change(user, status: RxStatus.success());
    } catch (e) {
      logger.e("Error fetching user profile: $e");
      change(null, status: RxStatus.error("Failed to fetch profile"));
    }
  }

  Future<void> login(String username, String password) async {
    try {
      change(null, status: RxStatus.loading());
      final response = await authService.login(username, password);

      await _storeAuthData(
        response.token,
        response.refreshToken,
        response.userId.toString(),
      );

      await _fetchUserProfile(response.userId.toString());
      logger.i("[AUTH_DEBUG] Logged in successfully");
    } catch (e) {
      logger.e("Login failed: $e");
      change(null, status: RxStatus.error("Login failed: ${e.toString()}"));
    }
  }

  Future<void> logout() async {
    try {
      change(null, status: RxStatus.loading());
      await _clearAuthToken();
      await authService.logout();
      change(null, status: RxStatus.empty());
      logger.i("[AUTH_DEBUG] Logged out successfully");
    } catch (e) {
      logger.e("Logout failed: $e");
      change(null, status: RxStatus.error("Logout failed"));
    }
  }

  Future<String?> _getAuthTokenFromStorage() async {
    return await secureStorage.read(key: 'accessToken');
  }

  Future<void> _storeAuthData(
      String token, String refreshToken, String userId) async {
    await secureStorage.write(key: 'accessToken', value: token);
    await secureStorage.write(key: 'refreshToken', value: refreshToken);
    await secureStorage.write(key: 'userId', value: userId);
  }

  Future<void> _clearAuthToken() async {
    await secureStorage.delete(key: 'accessToken');
    await secureStorage.delete(key: 'refreshToken');
    await secureStorage.delete(key: 'userId');
  }

  Future<String?> _decodeTokenAndGetUserId(String token) async {
    try {
      if (EnvConfig.isDebugProd || EnvConfig.isProduction) {
        // Production JWT decoding
        final parts = token.split('.');
        if (parts.length != 3) return null;

        final payload = jsonDecode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

        return payload['userId']?.toString();
      } else {
        // Development mock token handling
        return token == 'marek'
            ? (await secureStorage.read(key: 'userId'))
            : null;
      }
    } catch (e) {
      logger.e("Token decoding failed: $e");
      return null;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      change(null, status: RxStatus.loading());
      await authService.register(username, email, password);
      logger.i("Registration successful");

      // Show success message
      Get.snackbar(
        'Success',
        'Registration successful! Please login to continue.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      await Future.delayed(Duration(seconds: 1));
      Get.offNamed('/login');
    } catch (e) {
      logger.e("Registration failed: $e");
      change(null, status: RxStatus.error(e.toString()));

      // Show error message
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }
}
