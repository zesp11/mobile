// Displays user information and allows profile editing.
import 'package:get/get.dart';
import 'package:goadventure/app/models/user.dart';
import 'package:goadventure/app/services/user_service.dart';

// TODO: add logger library for logging

// class ProfileController extends GetxController {
//   final ApiService apiService = Get.find();

//   var userProfile = {}.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadUserProfile();
//   }

//   void loadUserProfile() async {
//     userProfile.value = await apiService.getUserProfile();
//   }

//   void updateUserProfile(Map<String, dynamic> updatedProfile) async {
//     await apiService.updateUserProfile(updatedProfile);
//     loadUserProfile();
//   }
// }

// Here we manage the state and logic for a specific page or feature.
// It should use the types defined in the service layer, ensuring it knows what
// kind of data it's dealing with
class ProfileController extends GetxController {
  final UserService userService; // Declare the UserService dependency

  ProfileController({required this.userService});

  var userProfile = Rx<UserProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    // TODO: change for fetching current user
    // maybe create UserOwnProfileController
    fetchUserProfile('1');
  }

  // TODO: don't ignore that parameter
  Future<void> fetchUserProfile(String id) async {
    try {
      userProfile.value = await userService.fetchUserProfile(id);
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  void updateProfile(String name, int gamesPlayed, int gamesFinished) {
    // Add your logic for updating the profile
    userProfile.value?.name = name;
    userProfile.value?.bio = 'Updated bio';
    userProfile.value?.preferences['gamesPlayed'] = gamesPlayed;
    userProfile.value?.preferences['gamesFinished'] = gamesFinished;
  }
}
