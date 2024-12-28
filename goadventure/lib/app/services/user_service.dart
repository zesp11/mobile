import 'package:goadventure/app/models/user.dart';
import 'package:goadventure/app/services/api_service/api_service.dart';

// The service should add types to responses returned from the ApiServices
class UserService {
  final ApiService apiService;

  UserService(this.apiService);

  Future<UserProfile> fetchUserProfile() async {
    try {
      final response = await apiService.getUserProfile();
      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }
}
