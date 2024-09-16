// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

class kLocation {
  final String? location;
  final String? error;
  final String? lat;
  final String? long;

  kLocation({this.location, this.error, this.lat, this.long});

  static fromJson(Map<String, dynamic> json) => kLocation(
      location: json["location_name"] as String? ?? '',
      lat: json["latitude"] as String? ?? '',
      long: json["longitude"] as String? ?? '');

  @override
  String toString() {
    return 'kLocation(location: $location, error: $error, lat: $lat, long: $long)';
  }
}
