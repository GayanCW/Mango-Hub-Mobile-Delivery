import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mangoHub/src/services/Services.dart';


class GoogleMapMyLocation extends StatefulWidget {
  @override
  State<GoogleMapMyLocation> createState() => GoogleMapMyLocationState();
}

class GoogleMapMyLocationState extends State<GoogleMapMyLocation> {
  Location location = Location();
  GoogleMapController _mapController;
  bool _showMapStyle = false;
  double _myLatitude = 0.00;
  double _myLongitude = 0.00;


  static final _initialCameraPosition = CameraPosition(
    target: LatLng(6.767679, 79.893027),
    zoom: 12.0,
  );

  void _onMapCreated(GoogleMapController controller) {
    _toggleMapStyle();
    _mapController = controller;
  }

  void _toggleMapStyle() async {
    String style = await DefaultAssetBundle.of(context).loadString('assets/googleMap/map_style2.json');

    if (_showMapStyle==true) {
      _mapController.setMapStyle(style);
    } else {
      _mapController.setMapStyle(null);
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return StreamBuilder<UserLocation>(
        stream: LocationService().locationStream,
        builder: (context, snapshot){

          if(!snapshot.hasData){
            Center(child: Text('Loading . . .'),);
          }
          if(snapshot.hasData) {
            _myLatitude = snapshot.data.latitude;
            _myLongitude = snapshot.data.longitude;

            if (_mapController != null) {
              _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                  bearing: 0.0,
                  target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                  tilt: 0,
                  zoom: 12.00
              )));
            }
          }

          return Stack(
            children: [
              Container(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ],
          );
        }
    );
  }
}
