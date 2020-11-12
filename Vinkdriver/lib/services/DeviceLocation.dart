import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as locationAccuracy;

class DeviceLocation {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position position;
  LocationData currentLocationData;

  Future<LatLng> getCurrentPosition() async {
    position = await geolocator.getCurrentPosition(
        desiredAccuracy: locationAccuracy.LocationAccuracy.high);
    var latLong = LatLng(position.latitude, position.longitude);
    return latLong;
  }

  Future<double> computeDistanceInMeters(
      LatLng previousPosition, LatLng currentLocation) async {
    print("on computeDistanceInMeters()");
    return await Geolocator().distanceBetween(
      previousPosition.latitude,
      previousPosition.longitude,
      currentLocation.latitude,
      currentLocation.longitude,
    );
  }
}
