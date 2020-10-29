
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mangoHub/src/blocs/GetNearbyCompanies/get_nearby_companies_bloc.dart';
import 'package:mangoHub/src/components/CircleProgress.dart';
import 'package:mangoHub/src/components/LoaderForm.dart';
import 'package:mangoHub/src/googleMap/GoogleMapObj.dart';
import 'package:mangoHub/src/models/APImodels/GetNearbyCompaniesModel.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/screens/OrderLocation.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:geolocator/geolocator.dart';

class Orders extends StatefulWidget {
  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends State<Orders> with SingleTickerProviderStateMixin{

  FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  List<NearbyCompanies> companyIdList = new List<NearbyCompanies>();
  List<OrderModel> allOrderCompanyIds = new List<OrderModel>();

  AnimationController progressController;
  Animation<double> animation;
  int orderSkipCount = 0;
  bool skipState=false;

  double _myLat=0.00; double _myLang=0.00;
  double _myLatitude=0.00,_myLongitude=0.00;
  double _shopLatitude, _shopLongitude;
  double _deliveryLatitude, _deliveryLongitude;

  double shopDistance = 0.00;
  double deliveryDistance = 0.00;
  int count;

  void listenChanges(){
    CollectionReference reference = FirebaseFirestore.instance.collection('OrderDelivery');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
      });
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //
  //   return BlocListener<GetNearbyCompaniesBloc,GetNearbyCompaniesState>(
  //     listener: (context, state){
  //       if(state is GetNearbyCompaniesSuccess){
  //           for(int index=0; index<state.getNearbyCompanies.nearbyCompanies.length; index++){
  //             NearbyCompanies _companyId = state.getNearbyCompanies.nearbyCompanies[index];
  //               companyIdList.add(
  //                 new NearbyCompanies(
  //                   sId: _companyId.sId
  //                 )
  //               );
  //           }
  //           print(companyIdList[0].sId);
  //           print(companyIdList[1].sId);
  //
  //       }
  //       if(state is GetNearbyCompaniesFailed){
  //         print("Failed");
  //       }
  //
  //       if(state is GetNearbyCompaniesFailedException){
  //         print(state.errorObject);
  //       }
  //     },
  //     child: BlocBuilder<GetNearbyCompaniesBloc,GetNearbyCompaniesState>(
  //       builder: (context,state){
  //         return streamLocation(context);
  //       }
  //     ),
  //   );
  // }
  //

  //
  // Widget streamLocation(BuildContext context){
  //   return StreamBuilder<UserLocation>(
  //     stream: LocationService().locationStream,
  //     builder: (context, snapshot){
  //       if(snapshot.hasData){
  //         _myLatitude = snapshot.data.latitude;
  //         _myLongitude = snapshot.data.longitude;
  //         listenChanges(_myLatitude,_myLongitude);
  //
  //       }
  //       return buildOrdersUI(context);
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // sendMyCurrentLocation();
    getMyLocation();
    progressController = AnimationController(vsync: this,duration: Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0.0,end: 100.0).animate(progressController)..addListener((){
      setState(() {});
    });
  }

  void sendMyCurrentLocation()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position.latitude!=null && position.longitude!=null) {
      _myLatitude = position.latitude;
      _myLongitude = position.longitude;
      BlocProvider.of<GetNearbyCompaniesBloc>(context).add(
          GetNearbyCompanies(
              latitude: _myLat,
              longitude: _myLang,
              distance: 1000000.00
          ));
      setState(() {});
    }
  }

  void getMyLocation()async{
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position.latitude!=null && position.longitude!=null) {
      _myLatitude = position.latitude;
      _myLongitude = position.longitude;
      setState(() {});
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    double p = 0.017453292519943295;
    double a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;

    return 12742 * asin(sqrt(a));
  }

  void _restartAnimation() {
    progressController.value = 0.0;
    setState(() {
      progressController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: _fireStoreDataBase.collection('OrderDelivery').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data.documents.map((document) => OrderModel.fromJson(document.data())).toList();
            List<OrderProductList> productList = new List<OrderProductList>();
            List<OrderAditionalCharges> additionalChargesList = new List<OrderAditionalCharges>();

            nearbyOrders.clear();
              for (int index = 0; index <
                  snapshot.data.documents.length; index++) {
                // productList.clear();
                // additionalChargesList.clear();
                _shopLatitude = double.parse(
                    snapshot.data.documents[index]['order_geo']['shop'].split(
                        ',')[0]);
                _shopLongitude = double.parse(
                    snapshot.data.documents[index]['order_geo']['shop'].split(
                        ',')[1]);

                _deliveryLatitude = double.parse(
                    snapshot.data.documents[index]['order_geo']['delivery']
                        .split(
                        ',')[0]);
                _deliveryLongitude = double.parse(
                    snapshot.data.documents[index]['order_geo']['delivery']
                        .split(
                        ',')[1]);

                shopDistance = calculateDistance(
                    _myLatitude, _myLongitude, _shopLatitude, _shopLongitude);
                deliveryDistance = calculateDistance(
                    _myLatitude, _myLongitude, _deliveryLatitude,
                    _deliveryLongitude);

                // print("shop: $shopDistance");
                // print("delivery: $deliveryDistance");

                if (shopDistance < 500.00 && deliveryDistance < 500.00) {
                  OrderGeo singleGeo = OrderGeo();
                  singleGeo.shop =
                  snapshot.data.documents[index]['order_geo']['shop'];
                  singleGeo.delivery =
                  snapshot.data.documents[index]['order_geo']['delivery'];

                  // productList.clear();
                  for (int prodIndex = 0; prodIndex <
                      snapshot.data.documents[index]['order_product_list']
                          .length; prodIndex++) {
                    productList.add(OrderProductList(
                      stockId: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_id'],
                      stockBaseProductId: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_base_product_id'],
                      stockVariantId: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_variant_id'],
                      stockVariantTag: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_variant_tag'],
                      stockUnitCost: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_unit_cost'],
                      stockUnitPrice: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_unit_price'],
                      stockUnitDiscountType: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_unit_discount_type'],
                      stockUnitDiscountValue: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_unit_discount_value'],
                      stockUnitDiscountAmount: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_unit_discount_amount'],
                      stockQty: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_qty'],
                      stockCompany: snapshot.data
                          .documents[index]['order_product_list'][prodIndex]['stock_company'],
                    ));
                  }

                  // additionalChargesList.clear();
                  for (int acIndex = 0; acIndex <
                      snapshot.data.documents[index]['order_aditional_charges']
                          .length; acIndex++) {
                    additionalChargesList.add(OrderAditionalCharges(
                      type: snapshot.data
                          .documents[index]['order_aditional_charges'][acIndex]['type'],
                      amount: snapshot.data
                          .documents[index]['order_aditional_charges'][acIndex]['amount'],
                    ));
                  }

                  nearbyOrders.add(OrderModel(
                    orderProductList: productList,
                    orderAditionalCharges: additionalChargesList,
                    orderGeo: singleGeo,
                    sId: snapshot.data.documents[index]['_id'],
                    orderDate: snapshot.data.documents[index]['order_date'],
                    orderCompany: snapshot.data
                        .documents[index]['order_company'],
                    orderBranchId: snapshot.data
                        .documents[index]['order_branch_id'],
                    orderCustomerId: snapshot.data
                        .documents[index]['order_customer_id'],
                    orderCustomerName: snapshot.data
                        .documents[index]['order_customer_name'],
                    orderCustomerMobile: snapshot.data
                        .documents[index]['order_customer_mobile'],
                    orderPaymentMethod: snapshot.data
                        .documents[index]['order_payment_method'],
                    orderAmount: snapshot.data.documents[index]['order_amount'],
                    orderDiscount: snapshot.data
                        .documents[index]['order_discount'],
                    orderTotal: snapshot.data.documents[index]['order_total'],
                    orderAdvancePayment: snapshot.data
                        .documents[index]['order_advance_payment'],
                    orderStatus: snapshot.data.documents[index]['order_status'],
                    orderStatusString: snapshot.data
                        .documents[index]['order_status_string'],
                    orderType: snapshot.data.documents[index]['order_type'],
                    orderAcceptedUserId: snapshot.data
                        .documents[index]['order_accepted_user_id'],
                    orderInvoiceId: snapshot.data
                        .documents[index]['order_invoice_id'],
                    orderDeliveryPersonId: snapshot.data
                        .documents[index]['order_delivery_person_id'],
                    createdAt: snapshot.data.documents[index]['createdAt'],
                    updatedAt: snapshot.data.documents[index]['updatedAt'],
                    iV: snapshot.data.documents[index]['__v'],
                  ));
                }
            }


            count = nearbyOrders.length;

            if(orderSkipCount < count){
              orderSkipCount = orderSkipCount;
            }
            if(orderSkipCount == count){
              orderSkipCount--;
            }
            if(orderSkipCount<0){
              orderSkipCount = 0;
            }

            // print(nearbyOrders.toString());




          }
          return Stack(
            children: [
              Container(
                  height: _size.height*0.65,
                  child: MapSample()
              ),
              Container(
                margin: EdgeInsets.only(top: _size.height*0.65, left: 10.0, right: 10.0),
                // color: Colors.orange,
                child: (nearbyOrders!=null)?GestureDetector(
                  child: Container(
                      width: _size.width,
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(2.0, 2.0),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),
                          Text(nearbyOrders[orderSkipCount].orderCustomerName ,style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                          Text("Your order is ${shopDistance.toStringAsFixed(1)} km away", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                          SizedBox(height: 10,),
                        ],
                      )
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderLocation(selectedIndex: orderSkipCount, myLatitude: _myLatitude, myLongitude: _myLongitude,)));
                  },
                ):
                Container(child: Center(child: Text('Waiting...')),),

                // Container(child: Center(child: SpinKitChasingDots(
                //   color: mangoBlue,
                //   size: 50.0,
                // )),),
              ),

              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    // color: Colors.white,
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: _size.height*0.575,),
                    child: CustomPaint(
                      foregroundPainter: CircleProgress(animation.value), // this will add custom painter after child
                      child: GestureDetector(
                        child: ClipRRect(
                          borderRadius:BorderRadius.circular(100) ,

                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.white,
                            child: Center(
                                child: (animation.value==100.0)?Icon(Icons.refresh, size: 60,color: mangoBlue,):Text("${animation.value.toInt()}",style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold
                                ),)),
                          ),
                        ),
                        onTap: (){
                          if(orderSkipCount<nearbyOrders.length-1) {
                            if (animation.value == 100) {
                              _restartAnimation();
                            }
                            if (animation.value == 0) {
                              progressController.forward();
                            }
                            orderSkipCount++;
                          }

                        },
                      ),
                    ),
                  )
                // child: MyHomePage(),
              ),
            ],
          );
        }
    );

  }
}
