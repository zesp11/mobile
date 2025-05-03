import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:latlong2/latlong.dart';

class LocationService extends GetxService {
  final logger = Get.find<Logger>();
  final RxString currentLocationName = ''.obs;
  final RxBool isLoadingLocation = false.obs;

  Future<String> getPlaceName(LatLng coordinates) async {
    try {
      isLoadingLocation.value = true;
      final placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final List<String> addressParts = [];

        if (place.street?.isNotEmpty ?? false) {
          addressParts.add(place.street!);
        }
        if (place.locality?.isNotEmpty ?? false) {
          addressParts.add(place.locality!);
        }
        if (place.country?.isNotEmpty ?? false) {
          addressParts.add(place.country!);
        }

        final locationName = addressParts.join(', ');
        currentLocationName.value = locationName;
        return locationName;
      }

      return 'Unknown location';
    } catch (e) {
      logger.e('Error getting place name: $e');
      return 'Location unavailable';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<List<String>> searchPlaces(String query) async {
    try {
      final locations = await locationFromAddress(query);
      return locations.map((location) {
        return '${location.latitude}, ${location.longitude}';
      }).toList();
    } catch (e) {
      logger.e('Error searching places: $e');
      return [];
    }
  }

  // Helper method to format coordinates into a human-readable string
  String formatCoordinates(LatLng coordinates) {
    return '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}';
  }
}
