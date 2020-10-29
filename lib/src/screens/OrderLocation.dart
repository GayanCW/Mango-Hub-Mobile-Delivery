import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mangoHub/src/blocs/GetNearbyCompanies/get_nearby_companies_bloc.dart';
import 'package:mangoHub/src/googleMap/GoogleMapObj.dart';
import 'package:mangoHub/src/models/APImodels/GetNearbyCompaniesModel.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/models/UImodels/LocationModel.dart';
import 'package:mangoHub/src/services/GoogleService.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class OrderLocation extends StatefulWidget {
  final int selectedIndex;
  final double myLatitude;
  final double myLongitude;
  OrderLocation({Key key,this.selectedIndex, this.myLatitude, this.myLongitude}):super(key: key);

  @override
  _OrderLocationState createState() => _OrderLocationState();
}

class _OrderLocationState extends State<OrderLocation> {

  Location location = Location();
  GoogleMapController _mapController;
  Set<Marker> _markers = HashSet<Marker>();
  bool _showMapStyle = false;


  bool markerCreateState=false;
  bool buttonVisibility=false;
  int markerCount=0;

  bool orderPicking = false;
  bool orderDelivering = false;

  double shopLat, shopLong;
  double deliveryLat, deliveryLong;
  double totalPrice;
  double totalAdditionalCharges = 0;

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
    buttonEnabled();
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
      _mapController.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 0.0,
              target: LatLng(latitude,longitude),
              tilt: 0,
              zoom: 16.00
          )));
      markerCreateState=false;
  }

  @override
  void initState() {
    super.initState();
    markerCreateState=true;
    BlocProvider.of<GetNearbyCompaniesBloc>(context).add(
        GetNearbyCompanies(
            latitude: widget.myLatitude,
            longitude: widget.myLongitude,
            distance: 500000.00
        ));
  }

  buttonEnabled(){
    Future.delayed(const Duration(milliseconds: 6000), () {
      setState(() {
        buttonVisibility=true;
        markerCreateState=false;
      });
    });
  }


  Widget buildUI(BuildContext context) {
    // setState(() {
      shopLat = (nearbyOrders!=null)? double.parse(nearbyOrders[widget.selectedIndex].orderGeo.shop.split(',')[0]): 0.00;
      shopLong = (nearbyOrders!=null)? double.parse(nearbyOrders[widget.selectedIndex].orderGeo.shop.split(',')[1]): 0.00;

      deliveryLat = (nearbyOrders!=null)? double.parse(nearbyOrders[widget.selectedIndex].orderGeo.delivery.split(',')[0]): 0.00;
      deliveryLong = (nearbyOrders!=null)? double.parse(nearbyOrders[widget.selectedIndex].orderGeo.delivery.split(',')[1]): 0.00;
    // });


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

            if(markerCount==0 && markerCreateState==true) {
              markerCount=1;
              orderPicking=true;
              orderDelivering=false;
              buttonVisibility=false;
              _setMarkers(shopLat, shopLong);
            }
            if(markerCount==1 && markerCreateState==true) {
              markerCount=2;
              orderPicking=false;
              orderDelivering=true;
              buttonVisibility=false;
              _setMarkers(deliveryLat, deliveryLong);
            }
        }

        return Scaffold(
          /*appBar: AppBar(
            title: Text("Location"),
            centerTitle: true,
            backgroundColor: mangoOrange,
            automaticallyImplyLeading: false
          ),*/
          body: Stack(
            children: [
              Container(
                height: _size.height * 0.7+70.0,
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
                    top: _size.height * 0.723+70.0,
                    bottom: 20.0,
                    left: 10.0,
                    right: 10.0),
                decoration: BoxDecoration(
                  color: (buttonVisibility==false)?Colors.grey: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: (orderPicking==true)?
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: (buttonVisibility==false)?null:(){
                      setState(() {
                        _markers.clear();
                        markerCreateState=true;
                      });
                    },
                    child: Center(child: Text("I'm On My Way", style: TextStyle(fontSize: 30, color: Colors.white),)),
                  ): (orderDelivering==true)?
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: (buttonVisibility==false)?null:(){
                      setState(() {
                        _markers.clear();
                        markerCreateState=true;
                      });
                    },
                    child: Center(child: Text("Delivered", style: TextStyle(fontSize: 30, color: Colors.white))),
                  ): null
              ),
              SlidingUpPanel(
                minHeight : 15.0,
                maxHeight : 300.0,
                panel: (orderPicking==true)?Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 10.0,
                      width: 150.0,
                      margin: EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: mangoOrange,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),

                    ),
                    Text(orderCompanyDetails[0].branchName, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),),
                      SizedBox(height: 10.0,),
                    Text(orderCompanyDetails[0].branchAddress.addressLine1, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                    Text(orderCompanyDetails[0].branchAddress.addressLine2, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                      SizedBox(height: 10.0,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 100.0),
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            color: mangoOrange,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: Colors.grey,),
                            SizedBox(width: 15.0,),
                            Text(orderCompanyDetails[0].branchTel, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),

                          ],),
                      ),
                    ),

                  ],
                ):
                (orderDelivering==true)?Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 10.0,
                      width: 150.0,
                      margin: EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                          color: mangoOrange,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),

                    ),
                    Text(nearbyOrders[widget.selectedIndex].orderCustomerName, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),),
                    SizedBox(height: 10.0,),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: mangoBlue),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: Column(children: [
                        Text("Total Price", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                        // Text("Rs: ${totalPrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),),
                        Text("Rs: ${nearbyOrders[widget.selectedIndex].orderTotal}", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),),

                      ],),
                    ),
                    Text(nearbyOrders[widget.selectedIndex].orderPaymentMethod, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),),
                    SizedBox(height: 10.0,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 100.0),
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            color: mangoOrange,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: Colors.grey,),
                            SizedBox(width: 15.0,),
                            Text(nearbyOrders[widget.selectedIndex].orderCustomerMobile, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),

                          ],),
                      ),
                    ),

                  ],
                ):
                    Container(),
              )

            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<GetNearbyCompaniesBloc,GetNearbyCompaniesState>(
      listener: (context, state){
        if(state is GetNearbyCompaniesSuccess){
          print('charges: ');
          print(nearbyOrders[widget.selectedIndex].orderAditionalCharges.length.toString());
          for (int index = 0; index < state.getNearbyCompanies.nearbyCompanies.length; index++) {
            NearbyCompanies _companyDetails = state.getNearbyCompanies.nearbyCompanies[index];

            print(_companyDetails.sId);
            if(nearbyOrders[widget.selectedIndex].orderBranchId == _companyDetails.sId){
              BranchAddress _branchAddress = BranchAddress(
                  addressLine1: _companyDetails.branchAddress.addressLine1,
                  addressLine2: _companyDetails.branchAddress.addressLine2,
                  country: _companyDetails.branchAddress.country,
                  district: _companyDetails.branchAddress.district,
                  city: _companyDetails.branchAddress.city,
                  zipCode: _companyDetails.branchAddress.zipCode
              );
              orderCompanyDetails.add(
                  NearbyCompanies(
                      branchAddress: _branchAddress,
                      sId: _companyDetails.sId,
                      branchName: _companyDetails.branchName,
                      branchTel: _companyDetails.branchTel,
                      branchLocation: _companyDetails.branchLocation,
                      branchStatus: _companyDetails.branchStatus,
                      branchStatusString: _companyDetails.branchStatusString,
                      branchType: _companyDetails.branchType,
                      branchCompany: _companyDetails.branchCompany,
                      createdAt: _companyDetails.createdAt,
                      updatedAt: _companyDetails.updatedAt,
                      iV: _companyDetails.iV
                  )
              );
            }
          }
          totalPrice = 0.00;
          totalAdditionalCharges = 0.00;

          for(int index=0; index<nearbyOrders[widget.selectedIndex].orderAditionalCharges.length; index++){
            totalAdditionalCharges = totalAdditionalCharges + nearbyOrders[widget.selectedIndex].orderAditionalCharges[index].amount;
          }
          totalPrice = nearbyOrders[widget.selectedIndex].orderTotal + totalAdditionalCharges;
          print(totalAdditionalCharges.toString());

          print("pro: ${nearbyOrders[widget.selectedIndex].orderProductList.length}");
          print(nearbyOrders[widget.selectedIndex].orderBranchId);
        }
        if(state is GetNearbyCompaniesFailed){

        }
        if(state is GetNearbyCompaniesFailedException){

        }
      },
      child: BlocBuilder<GetNearbyCompaniesBloc,GetNearbyCompaniesState>(
        builder: (context,state){
          return buildUI(context);
        }
      ),
    );
  }
}



