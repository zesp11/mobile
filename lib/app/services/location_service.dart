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
      Duration(milliseconds: 500); // Reduced from 1 second
  DateTime? _lastRequestTime;

  // Rate limiting
  static const int _maxRequestsPerMinute = 20; // Increased from 10
  final Queue<DateTime> _requestTimes = Queue<DateTime>();

  Map<String, dynamic> get _locationCache {
    final data = _storage.read(_cacheKey);
    // Sprawdzenie czy dane odczytane z pamięci są typu Map
    if (data == null) {
      return {};
    } else if (data is Map<String, dynamic>) {
      return data;
    } else {
      logger.e('Cache data has invalid format: $data');
      return {};
    }
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
      logger.w('Rate limit reached. Queue size: ${_requestTimes.length}');
      return false;
    }

    // Check throttle
    if (_lastRequestTime != null &&
        now.difference(_lastRequestTime!) < _requestThrottle) {
      logger.w(
          'Request throttled. Time since last request: ${now.difference(_lastRequestTime!).inMilliseconds}ms');
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

      logger.d(
          'Getting place name for coordinates: ${coordinates.latitude}, ${coordinates.longitude}');

      // Check cache first
      final cachedLocation = _checkCache(cacheKey);
      if (cachedLocation != null) {
        logger.d('Found cached location: $cachedLocation');
        currentLocationName.value = cachedLocation;
        isLoadingLocation.value = false; 
        return cachedLocation;
      }

      // Check rate limiting
      if (!_canMakeRequest()) {
        logger.w('Rate limit reached or throttled. Using coordinate string.');
        final coordStr = formatCoordinates(coordinates);
        isLoadingLocation.value = false;
        return coordStr;
      }

      // Make API request
      _lastRequestTime = DateTime.now();
      _requestTimes.add(_lastRequestTime!);

      logger.d('Making geocoding request...');
      List<Placemark> placemarks;
      try {
        placemarks = await placemarkFromCoordinates(
          coordinates.latitude,
          coordinates.longitude,
        );
      } catch (e) {
        logger.e('Error in placemarkFromCoordinates: $e');
        isLoadingLocation.value = false;
        return formatCoordinates(coordinates);
      }

      logger.d('Received placemarks: $placemarks');
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        String locationName;
        try {
          locationName = _formatAddress(place);
        } catch (e) {
          logger.e('Error formatting address: $e');
          isLoadingLocation.value = false;
          return formatCoordinates(coordinates);
        }
        logger.d('Formatted address: $locationName');

        // Cache the result
        _cacheLocation(cacheKey, locationName);
        currentLocationName.value = locationName;
        isLoadingLocation.value = false; 
        return locationName;
      }

      /*return formatCoordinates(coordinates);
    } catch (e, stackTrace) {
      logger.e('Error getting place name: $e\n$stackTrace');
      return formatCoordinates(coordinates);
    } finally {
      isLoadingLocation.value = false;
    }*/

    final coordStr = formatCoordinates(coordinates);
      isLoadingLocation.value = false;
      return coordStr;
    } catch (e, stackTrace) {
      logger.e('Error getting place name: $e\n$stackTrace');
      isLoadingLocation.value = false;
      return formatCoordinates(coordinates);
    }
  }

  String? _checkCache(String key) {
    try {
      final cache = _locationCache;
      final cachedData = cache[key];

      if (cachedData != null) {
        // Sprawdzenie czy cachedData ma właściwy format
        if (cachedData is Map && 
            cachedData.containsKey('timestamp') && 
            cachedData.containsKey('name')) {
          
          final timestampStr = cachedData['timestamp'];
          final locationName = cachedData['name'];
          
          if (timestampStr is String && locationName is String) {
            try {
              final timestamp = DateTime.parse(timestampStr);
              
              // Check if cache is still valid
              if (DateTime.now().difference(timestamp) < _cacheDuration) {
                return locationName;
              }
            } catch (e) {
              logger.e('Error parsing timestamp: $e');
            }
          }
        }
      }
    } catch (e) {
      logger.e('Error checking cache: $e');
    }
    return null;
  }
    /*final cache = _locationCache;
    final cachedData = cache[key];

    if (cachedData != null) {
      final timestamp = DateTime.parse(cachedData['timestamp']);
      final locationName = cachedData['name'];

      // Check if cache is still valid
      if (DateTime.now().difference(timestamp) < _cacheDuration) {
        return locationName;
      }
    }
    return null;*/

  void _cacheLocation(String key, String locationName) {
    try {
      final cache = _locationCache;
      cache[key] = {
        'name': locationName,
        'timestamp': DateTime.now().toIso8601String(),
      };
      _storage.write(_cacheKey, cache);
    } catch (e) {
      logger.e('Error caching location: $e');
      // Próba zresetowania pamięci podręcznej w przypadku poważnego błędu
      try {
        _storage.write(_cacheKey, {});
      } catch (e2) {
        logger.e('Error resetting cache: $e2');
      }
    }
    /*final cache = _locationCache;
    cache[key] = {
      'name': locationName,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _storage.write(_cacheKey, cache);*/
  }

  String _formatAddress(Placemark place) {
    final List<String> addressParts = [];

    try {
      if (place.street != null && place.street!.isNotEmpty) {
        addressParts.add(place.street!);
      }
      if (place.locality != null && place.locality!.isNotEmpty) {
        addressParts.add(place.locality!);
      }
      if (place.country != null && place.country!.isNotEmpty) {
        addressParts.add(place.country!);
      }
    } catch (e) {
      logger.e('Error building address parts: $e');
    }

    /*try {
      if (place.street?.isNotEmpty ?? false) {
        addressParts.add(place.street!);
      }
      if (place.locality?.isNotEmpty ?? false) {
        addressParts.add(place.locality!);
      }
      if (place.country?.isNotEmpty ?? false) {
        addressParts.add(place.country!);
      }
    } catch (e) {
      logger.e('Error building address parts: $e');
    }*/

    return addressParts.isEmpty ? 'Unknown location' : addressParts.join(', ');
  }

  Future<void> clearCache() async {
    try {
      await _storage.remove(_cacheKey);
    } catch (e) {
      logger.e('Error clearing cache: $e');
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

  String formatCoordinates(LatLng coordinates) {
    return '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}';
  }
}
