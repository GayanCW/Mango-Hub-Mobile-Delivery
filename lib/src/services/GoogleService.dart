import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:mangoHub/src/models/UImodels/LocationModel.dart';

class LocationService{

  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  StreamController<UserLocation> _locationController = StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  void getLocationPermission() async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  LocationService(){

    location.onLocationChanged.listen((locationData) {
      if (locationData != null) {
        _locationController.add(UserLocation(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
        ));
      }
    });
  }


}
