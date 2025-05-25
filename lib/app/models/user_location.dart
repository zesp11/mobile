import 'package:latlong2/latlong.dart';

class UserLocation {
  final String userId;
  final LatLng position;
  final String? photoUrl;
  final String login;

  UserLocation(
      {required this.userId,
      required this.position,
      this.photoUrl,
      required this.login});
}
