import 'package:latlong2/latlong.dart';

class MyCoordinates {

  double latitude;
  double longitude;

  MyCoordinates({
    required this.latitude,
    required this.longitude
  });

  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }

  MyCoordinates.fromJson(Map<String, dynamic> json)
      : latitude = json["latitude"],
        longitude = json["longitude"];

}