import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mangoHub/src/components/CircleProgress.dart';
import 'package:mangoHub/src/components/LoaderForm.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/screens/OrderLocation.dart';
import 'package:mangoHub/src/services/Services.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:mangoHub/src/shared/Repository.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final FirebaseServices _firebaseService = new FirebaseServices();
  final GeoLocationServices _locationServices = GeoLocationServices();
  GoogleMapController _mapController;
  Repository _repository = new Repository();
  DateTime now = DateTime.now();

  AnimationController progressController;
  Animation<double> animation;
  int orderSkipCount = 0;
  int skipCountInt = 0;
  String skipCountString;
  bool skipState = false;
  int selectedOrder = 0;
  int skipMaxCount = 100;

  double _shopLatitude, _shopLongitude;
  double _deliveryLatitude, _deliveryLongitude;
  double shopDistance = 0.00;
  double deliveryDistance = 0.00;

  bool isStop = true;

  final oCcy = new NumberFormat("#,##0.00", "en_US");

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(6.767679, 79.893027),
    zoom: 16,
  );

  void onMapCreated(GoogleMapController controller) {
    toggleMapStyle(false);
    _mapController = controller;
  }

  void toggleMapStyle(bool style) async {
    String _style = await DefaultAssetBundle.of(context).loadString('assets/googleMap/map_style2.json');

    if (style) {
      _mapController.setMapStyle(_style);
    } else {
      _mapController.setMapStyle(null);
    }
  }

  void _restartAnimation() {
    progressController.value = 0.0;
    setState(() {
      progressController.forward();
    });
  }

  void addOrderSkipCount(int skipCount) {
    _repository.addValue('skipCount', skipCount.toString());
  }

  void getOrderSkipCount() async {
    bool isDateChanged = await identifyDateChange();
    if(isDateChanged){
      _repository.deleteData('skipCount');
    }
    skipCountString = await _repository.readData('skipCount');
    skipCountInt = int.parse((skipCountString == null) ? '0' : skipCountString);
  }

  Future<bool>  identifyDateChange() async{
    bool isChanged = false;
    int year, month, day;
    String storedLocalTime = await _repository.readData('stored_local_time');

    if(storedLocalTime != null){
      year = int.parse(storedLocalTime.split('-')[0]);
      month = int.parse(storedLocalTime.split('-')[1]);
      day = int.parse(storedLocalTime.split('-')[2].split(' ')[0]);

      if(year != now.year){isChanged =  true;}
      if(month != now.month){isChanged =  true;}
      if(day != now.day){isChanged =  true;}

    } else{
      _repository.addValue('stored_local_time', now.toString());
    }

    if(isChanged){
      _repository.addValue('stored_local_time', now.toString());
    }

    return isChanged;

  }



  @override
  void initState() {
    super.initState();

    getOrderSkipCount();
    progressController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0.0, end: 100.0).animate(progressController)
          ..addListener(() {
            setState(() {});
          });



  }


  Widget buildUI(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    List<OrderModel> orderList = Provider.of<List<OrderModel>>(context, listen: true);
    Position _locationData = Provider.of<Position>(context, listen: true);
    nearbyOrders.clear();


    if (orderList != null && _locationData != null) {
      // print("My Location : ${_locationData.latitude} / ${_locationData.longitude} / ${_locationData.speed}");

      if(_mapController != null) {
        _mapController.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                bearing: 0.0,
                target: LatLng(_locationData.latitude, _locationData.longitude),
                tilt: 0,
                zoom: 12.00
            )));
      }

      if (orderList.isNotEmpty) {
        for (int index = 0; index < orderList.length; index++) {
          if (orderList[index].orderGeo != null && orderList[index].orderGeo.delivery != "" && orderList[index].orderGeo.shop != "") {
            _shopLatitude =
                double.parse(orderList[index].orderGeo.shop.split(',')[0]);
            _shopLongitude =
                double.parse(orderList[index].orderGeo.shop.split(',')[1]);

            _deliveryLatitude =
                double.parse(orderList[index].orderGeo.delivery.split(',')[0]);
            _deliveryLongitude =
                double.parse(orderList[index].orderGeo.delivery.split(',')[1]);

            shopDistance = Geolocator.distanceBetween(
                _locationData.latitude, _locationData.longitude, _shopLatitude,
                _shopLongitude);
            deliveryDistance = Geolocator.distanceBetween(
                _locationData.latitude, _locationData.longitude,
                _deliveryLatitude, _deliveryLongitude);

            // var strToDateTime = DateTime.parse(orderList[index].updatedAt);
            // final convertLocal = strToDateTime.toLocal();
            // print(convertLocal);
            // print(now.toUtc());


            if (shopDistance < 500000.00 /*&& deliveryDistance < 500.00*/) {
              if (orderList[index].orderDeliveryPersonId == "") {
                if (orderList[index].orderStatusString.toLowerCase() ==
                    "preparing" ||
                    orderList[index].orderStatusString.toLowerCase() ==
                        "ready") {
                  OrderGeo singleGeo = OrderGeo();
                  singleGeo.shop = orderList[index].orderGeo.shop;
                  singleGeo.delivery = orderList[index].orderGeo.delivery;

                  nearbyOrders.add(OrderModel(
                    orderProductList: orderList[index].orderProductList,
                    orderAdditionalCharges: orderList[index]
                        .orderAdditionalCharges,
                    orderGeo: singleGeo,
                    sId: orderList[index].sId,
                    orderDate: orderList[index].orderDate,
                    orderCompany: orderList[index].orderCompany,
                    orderBranchId: orderList[index].orderBranchId,
                    orderCustomerId: orderList[index].orderCustomerId,
                    orderCustomerName: orderList[index].orderCustomerName,
                    orderCustomerMobile: orderList[index].orderCustomerMobile,
                    orderPaymentMethod: orderList[index].orderPaymentMethod,
                    orderAmount: orderList[index].orderAmount,
                    orderDiscount: orderList[index].orderDiscount,
                    orderTotal: orderList[index].orderTotal,
                    orderAdvancePayment: orderList[index].orderAdvancePayment,
                    orderStatus: orderList[index].orderStatus,
                    orderStatusString: orderList[index]
                        .orderStatusString
                        .toString()
                        .toLowerCase(),
                    orderType: orderList[index].orderType,
                    orderAcceptedUserId: orderList[index].orderAcceptedUserId,
                    orderInvoiceId: orderList[index].orderInvoiceId,
                    orderDeliveryPersonId: orderList[index]
                        .orderDeliveryPersonId,
                    createdAt: orderList[index].createdAt,
                    updatedAt: orderList[index].updatedAt,
                    iV: orderList[index].iV,
                  ));
                }
              }
            }
          }
        }
      }

      if (orderSkipCount < nearbyOrders.length) {
        orderSkipCount = orderSkipCount;
      }
      if (orderSkipCount == nearbyOrders.length) {
        orderSkipCount--;
      }
      if (orderSkipCount < 0) {
        orderSkipCount = 0;
      }
    }

    return (orderList != null && _locationData != null)
        ? Stack(
            children: [
              Container(
                height: _size.height * 0.65,
                child: GoogleMap(
                  onMapCreated: onMapCreated,
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                    top: _size.height * 0.65, left: 10.0, right: 10.0),
                // color: Colors.orange,
                child: (nearbyOrders.length != 0)
                    ? Stack(
                        children: [
                          Container(
                            child: GestureDetector(
                              child: Container(
                                  width: _size.width,
                                  margin: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 5.0,
                                      right: 5.0),
                                  decoration: BoxDecoration(
                                      color: mangoBlack,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: mangoGrey,
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 2.0,
                                          spreadRadius: 1.0,
                                        ),
                                      ]),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                          nearbyOrders[orderSkipCount]
                                              .orderCustomerName,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white)),
                                      Text(
                                          'Rs. ' +
                                              oCcy.format(
                                                  nearbyOrders[orderSkipCount]
                                                      .orderAmount),
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w800,
                                              color: mangoOrange)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )),
                              onTap: () {
                                acceptedOrder.clear();
                                acceptedOrder.add(nearbyOrders[selectedOrder]);
                                LoaderFormState.showLoader(context, 'Loading . . .');
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute( //pushReplacement
                                    builder: (_) => OrderLocation(
                                      sId: acceptedOrder[0].sId,
                                      orderBranchId:
                                      acceptedOrder[0].orderBranchId,
                                      myLatitude: _locationData.latitude,
                                      myLongitude: _locationData.longitude,
                                    )), (route) => false);

                              },
                            ),
                          ),
                          Positioned(
                              right: 20.0,
                              bottom: 20.0,
                              child: Container(
                                child: (nearbyOrders[orderSkipCount]
                                            .orderPaymentMethod
                                            .toLowerCase() ==
                                        'cash')
                                    ? Icon(
                                        Icons.attach_money,
                                        color: Colors.green,
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.credit_card_outlined,
                                        color: Colors.green,
                                      ),
                              ))
                        ],
                      )
                    : Container(
                        color: mangoGrey,
                        child: Center(
                            child: Text(
                          'Waiting...',
                          style: TextStyle(color: mangoWhite),
                        )),
                      ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    // color: Colors.white,
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: _size.height * 0.575,
                    ),
                    child: (nearbyOrders.length != 0 &&
                            skipCountInt < skipMaxCount)
                        ? CustomPaint(
                            foregroundPainter: CircleProgress(animation.value),
                            // this will add custom painter after child
                            child: GestureDetector(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  color: mangoGrey,
                                  child: Center(
                                      child: (animation.value == 100.0)
                                          ? Icon(
                                              Icons.refresh,
                                              size: 60,
                                              color: mangoBlue,
                                            )
                                          : Text(
                                              "${animation.value.toInt()}",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: mangoWhite),
                                            )),
                                ),
                              ),
                              onTap: (skipCountInt < skipMaxCount)
                                  ? () async {
                                      if (orderSkipCount <
                                          nearbyOrders.length - 1) {
                                        skipCountString = await _repository
                                            .readData('skipCount');
                                        skipCountInt = int.parse(
                                            (skipCountString == null)
                                                ? '0'
                                                : skipCountString);
                                        skipCountInt++;
                                        if (animation.value == 100) {
                                          addOrderSkipCount(skipCountInt);
                                          _restartAnimation();
                                        }
                                        if (animation.value == 0) {
                                          addOrderSkipCount(skipCountInt);
                                          progressController.forward();
                                        }
                                        orderSkipCount++;
                                        selectedOrder = orderSkipCount;
                                      }
                                    }
                                  : null,
                            ),
                          )
                        : Container(),
                  )),
            ],
          )
        : Container(
          //   child: AlertDialog(
          //   contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   content: ClipRRect(
          //     borderRadius: BorderRadius.vertical(
          //         top: Radius.circular(30.0), bottom: Radius.circular(30.0)),
          //     child: Container(
          //       height: 60,
          //       width: 50,
          //       child: new Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Container(
          //             child: CircularProgressIndicator(
          //               backgroundColor: Colors.orange,
          //             ),
          //             // color: Colors.red,
          //             height: 30,
          //             width: 30,
          //           ),
          //           Container(
          //             margin: EdgeInsets.only(left: 20, top: 10),
          //             child: Text(
          //               'Loading     ',
          //               style: TextStyle(
          //                   color: mangoWhite,
          //                   fontSize: 14.0,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
          color: mangoGrey,
        );

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (BuildContext context) => _firebaseService.getAllOrders(),
        ),

        StreamProvider(
          create: (BuildContext context) => _locationServices.getMyLiveLocation(10000, 0)
        ),

    ],
      child: Builder(
        builder: (BuildContext context) {
          return buildUI(context);
        },
      ),
    );
  }
}

