// Displays user information and allows profile editing.
import 'dart:io';

import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/services/user_service.dart';
import 'package:gotale/app/utils/utils.dart' as utils;
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
class ProfileController extends GetxController with StateMixin<User> {
  final UserService userService; // Declare the UserService dependency
  final logger = Get.find<Logger>();
  final Rx<String> currentLocation = Rx<String>('Loading location...');

  ProfileController({required this.userService});

  var userProfile = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initialize the state with loading
    change(null, status: RxStatus.loading());
    getCurrentLocation();
  }

  // Fetch the current user's profile
  Future<void> fetchCurrentUserProfile() async {
    try {
      change(null, status: RxStatus.loading());
      // Fetch the profile and update the state with success
      userProfile.value = await userService.fetchCurrentUserProfile();
      change(userProfile.value, status: RxStatus.success());
    } catch (e) {
      // If an error occurs, change the state to error
      change(null, status: RxStatus.error('Error fetching user profile: $e'));
      logger.w('Error fetching user profile: $e');
    }
  }

  // Fetch a specific user's profile by ID
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

  Future<void> updateProfile(String login, String bio, String email,
      String? password, File? avatarFile) async {
    try {
      if (userProfile.value == null) {
        throw Exception('No user profile to update');
      }
      change(null, status: RxStatus.loading());

      final updateData = {
        'login': login,
        'bio': bio,
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
      };
      await userService.updateUserProfile(updateData, avatarFile);

      // Refetch user data from the server
      await fetchCurrentUserProfile();
      final authController = Get.find<AuthController>();
      authController.change(userProfile.value, status: RxStatus.success());

      // Update the state
      change(userProfile.value, status: RxStatus.success());
    } catch (e) {
      logger.e('Error updating profile: $e');
      change(null, status: RxStatus.error('Failed to update profile: $e'));
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        currentLocation.value = utils.formatPlacemarkAddress(place);
      } else {
        currentLocation.value =
            '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
      }
    } catch (e) {
      currentLocation.value = 'Location unavailable';
      logger.w('Error getting location: $e');
    }
  }
}
