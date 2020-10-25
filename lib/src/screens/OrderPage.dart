import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mangoHub/src/googleMap/GoogleMapObj.dart';
import 'package:mangoHub/src/models/UImodels/LocationModel.dart';
import 'package:mangoHub/src/services/GoogleService.dart';
import 'package:mangoHub/src/shared/Colors.dart';


/*class OrderPickUI extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
          centerTitle: true,
          backgroundColor: mangoOrange,
        ),
        body: OrderPick(),
    );
  }
}*/

class OrderPick extends StatefulWidget {
  final String shopGeo;
  OrderPick({Key key,this.shopGeo}):super(key: key);

  @override
  _OrderPickState createState() => _OrderPickState();
}

class _OrderPickState extends State<OrderPick> {

  Location location = Location();
  GoogleMapController _mapController;
  Set<Marker> _markers = HashSet<Marker>();
  bool _showMapStyle = true;
  bool orderSelectState = false;
  bool setMarkerState = false;
  double newLat, newLang;

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(6.767679, 79.893027),
    zoom: 16,
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

  void _setMarkers(double latitude, double longitude){
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId("My Location"),
            position: LatLng(latitude, longitude),
            // rotation: newLocalData.heading,
            draggable: false,
            zIndex: 0,
            flat: false,
            anchor: Offset(0.5, 1.09),
            icon: BitmapDescriptor.defaultMarker
        ),
      );
      orderSelectState=true;
      setMarkerState=true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setMarkerState=true;
    buttonEnabled();
  }

  buttonEnabled(){
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {
        orderSelectState=false;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    setState(() {});

    double lat = double.parse(widget.shopGeo.split(',')[0]);
    double lang = double.parse(widget.shopGeo.split(',')[1]);
    newLat = (lat!=null)?lat:0.00;
    newLang = (lang!=null)?lang:0.00;

    if(orderSelectState==false && setMarkerState==false) {
      _setMarkers(newLat, newLang);
    }

    Size _size = MediaQuery
        .of(context)
        .size;
    return StreamBuilder<UserLocation>(
      stream: LocationService().locationStream,
      builder: (context, snapshot) {
        /*if(snapshot.connectionState){
            if(ConnectionState.waiting){
              LoaderFormState.showLoader(context, 'Loading...');
            }
            if(ConnectionState.done){
              LoaderFormState.hideLoader(context);
            }
          }*/
        if (snapshot.hasData && _mapController != null) {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 0.0,
              target: (orderSelectState==false)?LatLng(snapshot.data.latitude, snapshot.data.longitude):LatLng(lat, lang),
              tilt: 0,
              zoom: (orderSelectState==false)?18.00: 16.00
          )));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Orders"),
            centerTitle: true,
            backgroundColor: mangoOrange,
          ),
          body: Stack(
            children: [
              Container(
                height: _size.height * 0.7,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: _size.height * 0.723,
                    bottom: 20.0,
                    left: 10.0,
                    right: 10.0),
                decoration: BoxDecoration(
                  color: (orderSelectState==false)?Colors.blue: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: (orderSelectState==false)?(){
                    // _setMarkers();
                    setState(() {
                      orderSelectState = false;
                    });
                  }: null,
                  child: Center(child: Text("I'm On My Way", style: TextStyle(fontSize: 30),)),
                ),
              ),

            ],
          ),
        );
      }
    );
  }
}



