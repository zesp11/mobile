import 'dart:async';
import 'dart:collection';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:latlong2/latlong.dart';
import 'package:get_storage/get_storage.dart';

class LocationService extends GetxService {
  final logger = Get.find<Logger>();
  final RxString currentLocationName = ''.obs;
  final RxBool isLoadingLocation = false.obs;
  final _storage = GetStorage();

  static const String _cacheKey = 'location_cache';
  static const Duration _cacheDuration =
      Duration(days: 30); // Cache for 30 days
  static const Duration _requestThrottle =
      Duration(seconds: 1); // Minimum time between requests
  DateTime? _lastRequestTime;

  // Rate limiting
  static const int _maxRequestsPerMinute = 10;
  final Queue<DateTime> _requestTimes = Queue<DateTime>();

  Map<String, dynamic> get _locationCache {
    return Map<String, dynamic>.from(_storage.read(_cacheKey) ?? {});
  }

  bool _canMakeRequest() {
    final now = DateTime.now();

    // Clean up old requests from queue
    while (_requestTimes.isNotEmpty &&
        now.difference(_requestTimes.first) > const Duration(minutes: 1)) {
      _requestTimes.removeFirst();
    }

    // Check rate limit
    if (_requestTimes.length >= _maxRequestsPerMinute) {
      return false;
    }

    // Check throttle
    if (_lastRequestTime != null &&
        now.difference(_lastRequestTime!) < _requestThrottle) {
      return false;
    }

    return true;
  }

  String _generateCacheKey(LatLng coordinates) {
    // Round to 4 decimal places to group nearby locations
    return '${coordinates.latitude.toStringAsFixed(4)},${coordinates.longitude.toStringAsFixed(4)}';
  }

  Future<String> getPlaceName(LatLng coordinates) async {
    try {
      isLoadingLocation.value = true;
      final cacheKey = _generateCacheKey(coordinates);

      // Check cache first
      final cachedLocation = _checkCache(cacheKey);
      if (cachedLocation != null) {
        currentLocationName.value = cachedLocation;
        return cachedLocation;
      }

      // Check rate limiting
      if (!_canMakeRequest()) {
        logger.w('Rate limit reached or throttled. Using coordinate string.');
        return formatCoordinates(coordinates);
      }

      // Make API request
      _lastRequestTime = DateTime.now();
      _requestTimes.add(_lastRequestTime!);

      final placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final locationName = _formatAddress(place);

        // Cache the result
        _cacheLocation(cacheKey, locationName);

        currentLocationName.value = locationName;
        return locationName;
      }

      return formatCoordinates(coordinates);
    } catch (e) {
      logger.e('Error getting place name: $e');
      return formatCoordinates(coordinates);
    } finally {
      isLoadingLocation.value = false;
    }
  }

  String? _checkCache(String key) {
    final cache = _locationCache;
    final cachedData = cache[key];

    if (cachedData != null) {
      final timestamp = DateTime.parse(cachedData['timestamp']);
      final locationName = cachedData['name'];

      // Check if cache is still valid
      if (DateTime.now().difference(timestamp) < _cacheDuration) {
        return locationName;
      }
    }
    return null;
  }

  void _cacheLocation(String key, String locationName) {
    final cache = _locationCache;
    cache[key] = {
      'name': locationName,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _storage.write(_cacheKey, cache);
  }

  String _formatAddress(Placemark place) {
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

    return addressParts.isEmpty ? 'Unknown location' : addressParts.join(', ');
  }

  Future<void> clearCache() async {
    await _storage.remove(_cacheKey);
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

  String formatCoordinates(LatLng coordinates) {
    return '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}';
  }
}
