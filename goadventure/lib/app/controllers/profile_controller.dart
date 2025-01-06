// Displays user information and allows profile editing.
import 'package:get/get.dart';
import 'package:goadventure/app/models/user.dart';
import 'package:goadventure/app/services/user_service.dart';
import 'package:logger/logger.dart';

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
class ProfileController extends GetxController with StateMixin<UserProfile> {
  final UserService userService; // Declare the UserService dependency
  final logger = Get.find<Logger>();

  ProfileController({required this.userService});

  var userProfile = Rx<UserProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initialize the state with loading
    change(null, status: RxStatus.loading());
  }

  // Fetch the user profile by ID
  Future<void> fetchUserProfile(String id) async {
    try {
      change(null, status: RxStatus.loading());
      // Fetch the profile and update the state with success
      userProfile.value = await userService.fetchUserProfile(id);
      change(userProfile.value, status: RxStatus.success());
    } catch (e) {
      // If an error occurs, change the state to error
      change(null, status: RxStatus.error('Error fetching user profile: $e'));
      logger.w('Error fetching user profile: $e');
    }
  }

  void updateProfile(String name, int gamesPlayed, int gamesFinished) {
    // Add your logic for updating the profile
    userProfile.value?.name = name;
    userProfile.value?.bio = 'Updated bio';
    userProfile.value?.preferences['gamesPlayed'] = gamesPlayed;
    userProfile.value?.preferences['gamesFinished'] = gamesFinished;
    // Trigger the update by notifying the state
    change(userProfile.value, status: RxStatus.success());
  }
}
