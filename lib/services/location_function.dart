import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello_world/models/location.dart';

//functions related to location

class LocationService {
  // Member variables (optional):
  // double? lat;
  // double? long;

  // Function to get current location
  Future<kLocation> getAddress() async {
    try {
      // print('object');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return kLocation(error: 'Enable Location');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return kLocation(error: 'Enable Location');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return kLocation(error: 'Enable Location');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // print(position.latitude);
      // print(position.longitude);
      String retrievedAddress =
          placemarks[0].subLocality! + "," + " " + placemarks[0].locality!;
      return kLocation(
          location: retrievedAddress,
          lat: position.latitude.toString(),
          long: position.longitude.toString());
    } catch (error) {
      return kLocation(error: 'Error getting location');
    }
  }
}
