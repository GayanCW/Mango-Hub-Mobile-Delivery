import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mangoHub/src/blocs/DeliveryFlow/delivery_flow_bloc.dart';
import 'package:mangoHub/src/blocs/GetNearbyCompanies/get_nearby_companies_bloc.dart';
import 'package:mangoHub/src/components/AlertBox.dart';
import 'package:mangoHub/src/models/APImodels/GetNearbyCompaniesModel.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/services/Services.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:mangoHub/src/shared/Repository.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:android_intent/android_intent.dart';

class OrderLocation extends StatefulWidget {
  final String sId;
  final String orderBranchId;
  final double myLatitude;
  final double myLongitude;
  OrderLocation({Key key, this.sId, this.orderBranchId, this.myLatitude, this.myLongitude}):super(key: key);

  @override
  _OrderLocationState createState() => _OrderLocationState();
}

class _OrderLocationState extends State<OrderLocation> {

  final FirebaseServices _firebaseServices = FirebaseServices();
  final GeoLocationServices _locationServices = GeoLocationServices();

  Repository _repository = new Repository();
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  Location location = Location();
  GoogleMapController _mapController;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  Set<Marker> _markers = HashSet<Marker>();

  bool markerCreateState=false;
  bool buttonVisibility=false;
  int markerCount=0;

  String _locationId;
  String _orderStatusString;

  bool orderDelivering = false;
  bool orderAccepted = false;

  double shopLat, shopLong;
  double deliveryLat, deliveryLong;
  double totalPrice;
  double totalAdditionalCharges = 0;

  bool distanceCalculating=false;
  double minimumUpdatingDistance = 20.0; // meters
  double oldLatitude, oldLongitude;
  double newLatitude, newLongitude;

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDhOoTKiPahx0kxP77CsMoQFcI61ivN4PU";

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(6.767679, 79.893027),
    zoom: 16,
  );

  void _onMapCreated(GoogleMapController controller) {
    _toggleMapStyle(false);
    _mapController = controller;
  }

  void _toggleMapStyle(bool style) async {
    String _style = await DefaultAssetBundle.of(context).loadString('assets/googleMap/map_style2.json');

    if (style) {
      _mapController.setMapStyle(_style);
    } else {
      _mapController.setMapStyle(null);
    }
  }

  void _setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0, size:  Size(5, 8)), 'assets/googleMap/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0, size:  Size(5, 8)),
        'assets/googleMap/buyer_pin.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  // double calculateDistance(double lat1, double lang1, double lat2, double lang2){
  //   double p = 0.017453292519943295;
  //   double a = 0.5 - cos((lat2 - lat1) * p)/2 +
  //       cos(lat1 * p) * cos(lat2 * p) *
  //           (1 - cos((lang2 - lang1) * p))/2;
  //
  //   return 12742 * asin(sqrt(a));
  // }

  void _setNewMarkers(double _latitude, double _longitude, BitmapDescriptor bitIcon){
      _markers.add(
        Marker(
            markerId: MarkerId("My Location"),
            position: LatLng(_latitude, _longitude),
            // rotation: newLocalData.heading,
            draggable: false,
            zIndex: 0,
            flat: false,
            anchor: Offset(0.5, 1.0),
            icon: BitmapDescriptor.defaultMarker
            // icon: bitIcon,
        ),
      );
      _mapController.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              bearing: 0.0,
              target: LatLng(_latitude,_longitude),
              tilt: 0,
              zoom: 12.00
          )));
      markerCreateState=false;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: mangoBlue, points: polylineCoordinates, width: 10, startCap: Cap.roundCap, endCap: Cap.buttCap);
    polylines[id] = polyline;
    // setState(() {});
  }

  _getPolyline(double _originLatitude, double _originLongitude, double _destLatitude, double _destLongitude) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    );
    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _buttonEnabled(String key){
    if(key=='time') {
      Future.delayed(const Duration(milliseconds: 10000), () {
          buttonVisibility = true;
          markerCreateState = false;
      });
    }

    if(key=='auto'){
        buttonVisibility=true;
        markerCreateState=false;
    }
  }

  void _getNearbyCompany(double latitude, double longitude, BuildContext context){
    BlocProvider.of<GetNearbyCompaniesBloc>(context).add(
        GetNearbyCompanies(
            latitude: latitude,
            longitude: longitude,
            distance: 500000.00
        )
    );
  }

  void _selectDeliveryFlow(String flow , int index, BuildContext context)async{

    String _userProfileId = await _repository.readData('userProfileId');
    print(_userProfileId);

    OrderGeo _geoCoordinates = new OrderGeo(
        shop: acceptedOrder[index].orderGeo.shop,
        delivery: acceptedOrder[index].orderGeo.delivery
    );
    OrderModel _deliveryFlow = new OrderModel(
        orderGeo:  _geoCoordinates,
        orderProductList: acceptedOrder[index].orderProductList,
        orderAditionalCharges: acceptedOrder[index].orderAditionalCharges,
        sId:  acceptedOrder[index].sId,
        orderDate:  acceptedOrder[index].orderDate,
        orderCompany: acceptedOrder[index].orderCompany,
        orderBranchId:  acceptedOrder[index].orderBranchId,
        orderCustomerId:  acceptedOrder[index].orderCustomerId,
        orderCustomerName:  acceptedOrder[index].orderCustomerName,
        orderCustomerMobile:  acceptedOrder[index].orderCustomerMobile,
        orderPaymentMethod: acceptedOrder[index].orderPaymentMethod,
        orderAmount:  acceptedOrder[index].orderAmount,
        orderDiscount:  acceptedOrder[index].orderDiscount,
        orderTotal: acceptedOrder[index].orderTotal,
        orderStatus:  acceptedOrder[index].orderStatus,
        orderStatusString:  acceptedOrder[index].orderStatusString.toLowerCase(),
        orderType:  acceptedOrder[index].orderType,
        orderAcceptedUserId:  acceptedOrder[index].orderAcceptedUserId,
        orderInvoiceId: acceptedOrder[index].orderInvoiceId,
        orderDeliveryPersonId:  _userProfileId
    );

    if(flow == 'AcceptDelivery'){
      BlocProvider.of<DeliveryFlowBloc>(context).add(
        AcceptDelivery(_deliveryFlow)
      );
    }

    if(flow == 'DeliveredOrder'){
      BlocProvider.of<DeliveryFlowBloc>(context).add(
          DeliveredOrder(_deliveryFlow)
      );
    }

  }

  void _launchTurnByTurnNavigationInGoogleMaps(double latitude, double longitude) {
    final AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull(
            'google.navigation:q=$latitude,$longitude'),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  bool locationUpdate(double updateLat, double updateLong){
    bool _locationUpdate;
    if(distanceCalculating==true){
      newLatitude = updateLat;
      newLongitude = updateLong;
      // double updatedDistance = 1000*calculateDistance(oldLatitude, oldLongitude, newLatitude, newLongitude);
      double updatedDistance = Geolocator.distanceBetween(oldLatitude, oldLongitude, newLatitude, newLongitude);

      if(updatedDistance>=minimumUpdatingDistance){
        distanceCalculating=false;
        _locationUpdate=true;
      }
      else{
        distanceCalculating=true;
        _locationUpdate=false;
      }
    }
    if(distanceCalculating==false){
      oldLatitude = updateLat;
      oldLongitude = updateLong;
      distanceCalculating=true;
      _locationUpdate=true;
    }

    return _locationUpdate;
  }


  @override
  void initState() {
    print('Location initState');
    super.initState();

    _locationId = 'shop';
    markerCreateState=true;

    _setSourceAndDestinationIcons();
    _getNearbyCompany(widget.myLatitude, widget.myLongitude, context);
    _selectDeliveryFlow('AcceptDelivery', 0, context);

  }

  Widget buildUI(BuildContext context){
    // print('location buildUI');
    Size _size = MediaQuery.of(context).size;
    OrderModel _acceptedOrder = Provider.of<OrderModel>(context);
    Position _locationData = Provider.of<Position>(context);


    if (_acceptedOrder != null && _locationData != null && _mapController != null) {

      bool _locationUpdate = locationUpdate(_locationData.latitude, _locationData.longitude);

      acceptedOrder.clear();
      acceptedOrder.add(_acceptedOrder);

      shopLat = double.parse(acceptedOrder[0].orderGeo.shop.split(',')[0]);
      shopLong = double.parse(acceptedOrder[0].orderGeo.shop.split(',')[1]);
      deliveryLat = double.parse(acceptedOrder[0].orderGeo.delivery.split(',')[0]);
      deliveryLong = double.parse(acceptedOrder[0].orderGeo.delivery.split(',')[1]);

      // print("My Location : ${_locationData.latitude} / ${_locationData.longitude}");
      if(_locationUpdate==true){
        _firebaseServices.addDriver(
            acceptedOrder[0].orderCustomerId,
            "${_locationData.latitude},${_locationData.longitude}",
            "${_locationData.speed}"
        );
      }


      if(_locationId == 'shop') {
        _orderStatusString = 'accepted';
          if(markerCreateState==true) {
            // _buttonEnabled('time'); // must be commented..................
            _setNewMarkers(shopLat, shopLong, sourceIcon);
              if(_locationUpdate==true){
                _getPolyline(_locationData.latitude, _locationData.longitude, shopLat, shopLong);
              }
          }
          else{
            // double _distance = calculateDistance(_locationData.latitude, _locationData.longitude, shopLat, shopLong);
            double _distance = Geolocator.distanceBetween(_locationData.latitude, _locationData.longitude, shopLat, shopLong);

            if(_distance<100){
              _buttonEnabled('auto');
            }
            if(acceptedOrder[0].orderStatusString.toLowerCase()=='handover'){
                _markers.clear();
                polylineCoordinates.clear();
                markerCreateState=true;
                buttonVisibility=false;
                distanceCalculating=false;

                _locationId='buyer';
            }
            if(_locationUpdate==true){
              _getPolyline(_locationData.latitude, _locationData.longitude, shopLat, shopLong);
            }
          }
      }

      if(_locationId == 'buyer') {
        _orderStatusString = 'picked';
          if(markerCreateState==true) {
            _buttonEnabled('time'); // must be commented........................
            _setNewMarkers(deliveryLat, deliveryLong, destinationIcon);
            if(_locationUpdate==true){
              _getPolyline(_locationData.latitude, _locationData.longitude, deliveryLat, deliveryLong); // need to change _getPolyline(_latLang.latitude, _latLang.longitude, deliveryLat, deliveryLong)
            }
          }
          else {
            // double _distance = calculateDistance(_locationData.latitude, _locationData.longitude, deliveryLat, deliveryLong);
            double _distance = Geolocator.distanceBetween(_locationData.latitude, _locationData.longitude, deliveryLat, deliveryLong);

            if (_distance < 100) {
              _buttonEnabled('auto');
            }
            if(_locationUpdate==true){
              _getPolyline(_locationData.latitude, _locationData.longitude, deliveryLat, deliveryLong); // need to change _getPolyline(_latLang.latitude, _latLang.longitude, deliveryLat, deliveryLong)
            }
          }
      }

    }

    return Scaffold(
      backgroundColor: mangoGrey,
      appBar: AppBar(
          title: Text("Location".toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: mangoOrange)),
          centerTitle: true,
          backgroundColor: mangoGrey,
          automaticallyImplyLeading: true
      ),
      body: (_acceptedOrder != null && _locationData != null)?Stack(
        children: [
          Container(
            height: _size.height * 0.5,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),

          Container(
              margin: EdgeInsets.only(
                  top: _size.height * 0.5+5.0,
                  bottom: _size.height * 0.28,
                  left: 10.0,
                  right: 10.0),
              decoration: BoxDecoration(
                color: (buttonVisibility==false)?Colors.grey: mangoOrange,
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              child:
                (_orderStatusString=='accepted')? FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: (buttonVisibility==false)?null:(){

                    setState(() {
                      showReceiptDialog(context,
                          'Order Details',
                          acceptedOrder[0].orderPaymentMethod,
                          acceptedOrder[0].orderTotal.toDouble(),
                          acceptedOrder[0].orderInvoiceId,
                          acceptedOrder[0].sId
                      );
                    });
                  },
                  child: Center(child: Text("Pick Your Delivery", style: TextStyle(fontSize: 30, color: mangoGrey),)),
                ):
                (_orderStatusString=='picked')? FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: (buttonVisibility==false)?null:(){
                    _selectDeliveryFlow('DeliveredOrder', 0, context);
                    setState(() {
                      _markers.clear();
                      polylineCoordinates.clear();
                      markerCreateState=true;
                      buttonVisibility=false;
                      _orderStatusString='delivered';
                    });
                  },
                  child: Center(child: Text("Delivered", style: TextStyle(fontSize: 30, color: mangoGrey))),
                ):
                null
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(
                  top: _size.height * 0.41,
                  right: 15.0),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: mangoBlue,
                child: IconButton(
                  icon: Icon(Icons.navigation_outlined),
                  onPressed: () =>
                    (_orderStatusString=='accepted')?_launchTurnByTurnNavigationInGoogleMaps(shopLat, shopLong):
                    (_orderStatusString=='picked')?_launchTurnByTurnNavigationInGoogleMaps(deliveryLat, deliveryLong):
                    null,
                ),
              ),
            ),
          ),

          SlidingUpPanel(
            minHeight : _size.height * 0.28 - 5.0,
            maxHeight : 500.0,
            panel:
              (_orderStatusString=='accepted' && orderCompanyDetails.isNotEmpty)?Container(
                color: mangoGrey,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 10.0,
                          width: 150.0,
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                              color: mangoOrange,
                              borderRadius: BorderRadius.circular(10.0)
                          ),

                        ),
                        Container(
                            width: double.infinity,
                            child: Center(child: Text("Pick up Details", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400, color: mangoWhite),))),
                        SizedBox(height: 20.0,),

                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(orderCompanyDetails[0].branchName, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600, color: mangoWhite),),
                          SizedBox(height: 10.0,),
                          Text(orderCompanyDetails[0].branchAddress.addressLine1, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: mangoWhite),),
                          Text(orderCompanyDetails[0].branchAddress.addressLine2, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: mangoWhite),),

                          SizedBox(height: 30.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Spacer(),
                              GestureDetector(
                                onTap: (){},
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                      color: mangoOrange,
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  child:  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.phone, color: mangoWhite,),
                                        SizedBox(width: 15.0,),
                                        Text(orderCompanyDetails[0].branchTel, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: mangoWhite),),

                                      ],),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ):
              (_orderStatusString=='picked' && orderCompanyDetails.isNotEmpty)?Container(
                color: mangoGrey,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 10.0,
                      width: 150.0,
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                          color: mangoOrange,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),

                    ),
                    Container(
                        width: double.infinity,
                        child: Center(child: Text("Buyer Details", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400, color: mangoWhite),))),
                    SizedBox(height: 20.0,),

                    Text(acceptedOrder[0].orderCustomerName, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600, color: mangoWhite),),
                    SizedBox(height: 10.0,),

                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: mangoBlue),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: Column(children: [
                        Text("Total Price", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: mangoWhite),),
                        // Text("Rs: ${totalPrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),),
                        Text('Rs.' +oCcy.format(acceptedOrder[0].orderTotal), style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400, color: mangoOrange),),

                      ],),
                    ),
                    Text(acceptedOrder[0].orderPaymentMethod.toUpperCase(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300, color: Colors.green),),
                    SizedBox(height: 10.0,),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 100.0),
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            color: mangoOrange,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        child:  Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, color: mangoWhite,),
                              SizedBox(width: 15.0,),
                              Text(acceptedOrder[0].orderCustomerMobile, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: mangoWhite),),

                            ],),
                        ),
                      ),
                    ),

                  ],
                ),
              ):
              Container(color: mangoGrey,),
          ),

        ],
      ):Center(child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0), bottom: Radius.circular(30.0)),
          child: Container(
            height: 60,
            width: 50,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                  ),
                  // color: Colors.red,
                  height: 30,
                  width: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20,top: 10),
                  child: Text(
                    'Loading     ',
                    style: TextStyle(
                        color: mangoWhite,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (BuildContext context) => _firebaseServices.getAcceptedOrder(widget.sId),
          catchError: (_, __) => null,
        ),
        StreamProvider(
          create: (BuildContext context) => _locationServices.getMyLiveLocation(),
          catchError: (_, __) => null,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetNearbyCompaniesBloc,GetNearbyCompaniesState>(
              listener: (context, state){
                if(state is GetNearbyCompaniesSuccess){
                  int index = 0;
                  while (index < state.getNearbyCompanies.nearbyCompanies.length) {
                    NearbyCompanies _companyDetails = state.getNearbyCompanies.nearbyCompanies[index];

                    print(_companyDetails.sId);
                    if(widget.orderBranchId == _companyDetails.sId){
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

                      index=state.getNearbyCompanies.nearbyCompanies.length;
                    }
                    else{
                      index++;
                    }
                  }
                  print(orderCompanyDetails[0].sId);
                  print(widget.orderBranchId);

                  totalPrice = 0.00;
                  totalAdditionalCharges = 0.00;

                }
                if(state is GetNearbyCompaniesFailed){

                }
                if(state is GetNearbyCompaniesFailedException){

                }
              }
          ),

          BlocListener<DeliveryFlowBloc,DeliveryFlowState>(
              listener: (context, state){
                if(state is AcceptedDeliverySuccess){
                  print('Accepted Success');
                }
                if(state is AcceptedDeliveryFailed){
                  print('Accepted Failed');
                }
                if(state is AcceptedDeliveryFailedException){

                }

                if(state is DeliveredDeliverySuccess){
                  showAlertDialog(context,'Delivery', 'Delivered Successfully');
                  Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
                }
                if(state is DeliveredDeliveryFailed){

                }
                if(state is DeliveredDeliveryFailedException){

                }

              }
          ),
        ],
        child: BlocBuilder<GetNearbyCompaniesBloc,GetNearbyCompaniesState>(
            builder: (context,state){
              return buildUI(context);
            }
        ),
      ),
      // child: Builder(
      //   builder: (BuildContext context){
      //     return
      //   }),
    );
  }
}




