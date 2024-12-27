// Displays user information and allows profile editing.
import 'package:get/get.dart';
import 'package:goadventure/app/services/api_service.dart';

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
class ProfileController extends GetxController {
  final ApiService apiService; // Declare the ApiService dependency

  // Reactive variables
  var userName = 'John Doe'.obs;
  var gamesPlayed = 15.obs;
  var gamesFinished = 10.obs;

  // Constructor accepting ApiService
  ProfileController({required this.apiService});

  // TODO: Implement method to fetch actual profile data in the future
  void updateProfile(String name, int played, int finished) {
    userName.value = name;
    gamesPlayed.value = played;
    gamesFinished.value = finished;
  }
}
