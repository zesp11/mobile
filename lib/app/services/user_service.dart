import 'dart:io';

import 'package:get/get.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:logger/logger.dart';

// The service should add types to responses returned from the ApiServices
class UserService {
  final ApiService apiService;

  UserService({required this.apiService});

  Future<User> fetchUserProfile(String id) async {
    try {
      return apiService.getUserProfile(id);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<User> fetchCurrentUserProfile() async {
    try {
      return apiService.getCurrentUserProfile();
    } catch (e) {
      throw Exception('Failed to fetch current user profile: $e');
    }
  }

  Future<void> updateUserProfile(
      Map<String, dynamic> profileData, File? avatarFile) async {
    try {
      await apiService.updateUserProfile(profileData, avatarFile);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}
