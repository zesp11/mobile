import 'package:goadventure/app/models/user.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';

// The service should add types to responses returned from the ApiServices
class UserService {
  final ApiService apiService;

  UserService({required this.apiService});

  Future<UserProfile> fetchUserProfile(String id) async {
    try {
      final response = await apiService.getUserProfile(id);
      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }
}
