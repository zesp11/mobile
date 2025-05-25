import 'package:geocoding/geocoding.dart';

String formatPlacemarkAddress(Placemark place) {
  // If place is null or any property is null, it'll default to an empty string
  String address = [
    place.subLocality ?? '',
    place.street ?? '',
    place.locality ?? '',
    // place.postalCode ?? '',
    // place.country ?? ''
  ].where((element) => element.isNotEmpty).join(', ');

  // Removing any trailing commas or spaces
  return address.replaceAll(RegExp(r',\s*$'), '');
}
