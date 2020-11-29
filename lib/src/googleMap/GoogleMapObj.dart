import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mangoHub/src/blocs/GetNearbyCompanies/get_nearby_companies_bloc.dart';
import 'package:mangoHub/src/models/APImodels/GetNearbyCompaniesModel.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/services/Services.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  double _myLatitude = 0.00;
  double _myLongitude = 0.00;
  double lat,lang;

  Location location = Location();
  GoogleMapController _mapController;
  bool _showMapStyle = false;
  bool apiCallState = false;
  List<OrderProductList> productList = new List<OrderProductList>();
  List<OrderAditionalCharges> additionalChargesList = new List<OrderAditionalCharges>();

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

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }


  @override
  void initState() {
    super.initState();
    // LocationService().getLocationPermission();
    // listenFirestoreChange();
    // apiCallState = true;

  }


  /*@override
  Widget build(BuildContext context) {
    return BlocListener<GetNearbyCompaniesBloc,GetNearbyCompaniesState>(
      listener: (context, state){
        if(state is GetNearbyCompaniesSuccess) {
          orderAllDetails.clear();
          productList.clear();
          additionalChargesList.clear();
          nearbyCompaniesList.clear();

          for (int index = 0; index < state.getNearbyCompanies.nearbyCompanies.length; index++) {
            NearbyCompanies _companyDetails = state.getNearbyCompanies.nearbyCompanies[index];
            BranchAddress _branchAddress = BranchAddress(
                addressLine1: _companyDetails.branchAddress.addressLine1,
                addressLine2: _companyDetails.branchAddress.addressLine2,
                country: _companyDetails.branchAddress.country,
                district: _companyDetails.branchAddress.district,
                city: _companyDetails.branchAddress.city,
                zipCode: _companyDetails.branchAddress.zipCode
            );
            nearbyCompaniesList.add(
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

            for (int index1 = 0; index1 < allOrderCompanies.length; index1++) {
              for (int index2 = 0; index2 < nearbyCompaniesList.length; index2++) {
                if(allOrderCompanies[index1].orderBranchId == nearbyCompaniesList[index2].sId){
                  *//*if(allOrderCompanies[index1].orderGeo.delivery!= null) {
                     lat = double.parse(
                        allOrderCompanies[index1].orderGeo.delivery.split(
                            ',')[0]);
                     lang = double.parse(
                        allOrderCompanies[index1].orderGeo.delivery.split(
                            ',')[1]);
                  }else{
                     lat = 6.79888;
                     lang = 79.89999;
                  }
                  if(calculateDistance(_myLatitude,_myLongitude, lat,lang)<10000.00) {*//*
                    OrderGeo singleGeo = OrderGeo();
                    singleGeo.shop = allOrderCompanies[index1].orderGeo.shop;
                    singleGeo.delivery = allOrderCompanies[index1].orderGeo.delivery;

                    for (int prodIndex = 0; prodIndex <
                        allOrderCompanies[index1].orderProductList
                            .length; prodIndex++) {
                      productList.add(OrderProductList(
                        stockId: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockId,
                        stockBaseProductId: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockBaseProductId,
                        stockVariantId: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockVariantId,
                        stockVariantTag: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockVariantTag,
                        stockUnitCost: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockUnitCost,
                        stockUnitPrice: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockUnitPrice,
                        stockUnitDiscountType: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockUnitDiscountType,
                        stockUnitDiscountValue: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockUnitDiscountValue,
                        stockUnitDiscountAmount: allOrderCompanies[index1]
                            .orderProductList[prodIndex]
                            .stockUnitDiscountAmount,
                        stockQty: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockQty,
                        stockCompany: allOrderCompanies[index1]
                            .orderProductList[prodIndex].stockCompany,
                      ));
                    }

                    for (int acIndex = 0; acIndex <
                        allOrderCompanies[index1].orderAditionalCharges
                            .length; acIndex++) {
                      additionalChargesList.add(OrderAditionalCharges(
                        type: allOrderCompanies[index1]
                            .orderAditionalCharges[acIndex].type,
                        amount: allOrderCompanies[index1]
                            .orderAditionalCharges[acIndex].amount,
                      ));
                    }

                    orderAllDetails.add(OrderModel(
                      orderProductList: productList,
                      orderAditionalCharges: additionalChargesList,
                      orderGeo: singleGeo,
                      sId: allOrderCompanies[index1].sId,
                      orderDate: allOrderCompanies[index1].orderDate,
                      orderCompany: allOrderCompanies[index1].orderCompany,
                      orderBranchId: allOrderCompanies[index1].orderBranchId,
                      orderCustomerId: allOrderCompanies[index1]
                          .orderCustomerId,
                      orderCustomerName: allOrderCompanies[index1]
                          .orderCustomerName,
                      orderCustomerMobile: allOrderCompanies[index1]
                          .orderCustomerMobile,
                      orderPaymentMethod: allOrderCompanies[index1]
                          .orderPaymentMethod,
                      orderAmount: allOrderCompanies[index1].orderAmount,
                      orderDiscount: allOrderCompanies[index1].orderDiscount,
                      orderTotal: allOrderCompanies[index1].orderTotal,
                      orderAdvancePayment: allOrderCompanies[index1]
                          .orderAdvancePayment,
                      orderStatus: allOrderCompanies[index1].orderStatus,
                      orderStatusString: allOrderCompanies[index1]
                          .orderStatusString,
                      orderType: allOrderCompanies[index1].orderType,
                      orderAcceptedUserId: allOrderCompanies[index1]
                          .orderAcceptedUserId,
                      orderInvoiceId: allOrderCompanies[index1].orderInvoiceId,
                      orderDeliveryPersonId: allOrderCompanies[index1]
                          .orderDeliveryPersonId,
                      createdAt: allOrderCompanies[index1].createdAt,
                      updatedAt: allOrderCompanies[index1].updatedAt,
                      iV: allOrderCompanies[index1].iV,
                    ));
                  // }
                }
              }
            }

          // OrdersState().refreshPage();
          //   print("shops: ${orderAllDetails.length}");

        }
        if(state is GetNearbyCompaniesFailed){
          print("Failed");
        }

        if(state is GetNearbyCompaniesFailedException){
          print(state.errorObject);
        }
      },
      child: BlocBuilder<GetNearbyCompaniesBloc,GetNearbyCompaniesState>(
          builder: (context,state){
            return buildGoogleMap(context);
          }
      ),
    );
  }

  void listenFirestoreChange(){
    CollectionReference reference = FirebaseFirestore.instance.collection('OrderDelivery');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        apiCallState = true;
        print('something changed: ');
      });
    });
    // streamSub.cancel();
  }*/
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return StreamBuilder<UserLocation>(
      stream: LocationService().locationStream,
      builder: (context, snapshot){
        /*if(snapshot.connectionState){
          if(ConnectionState.waiting){
            LoaderFormState.showLoader(context, 'Loading...');
          }
          if(ConnectionState.done){
            LoaderFormState.hideLoader(context);
          }
        }*/
        if(!snapshot.hasData){
          Center(child: Text('Loading . . .'),);
        }
        if(snapshot.hasData) {
          _myLatitude = snapshot.data.latitude;
          _myLongitude = snapshot.data.longitude;

          /*if(apiCallState==true){
            BlocProvider.of<GetNearbyCompaniesBloc>(context).add(
              GetNearbyCompanies(
                  latitude: _myLatitude,
                  longitude: _myLongitude,
                  distance: 10000.00
              ));
          }
          apiCallState = false;*/
          if (_mapController != null) {
            _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                bearing: 0.0,
                target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                tilt: 0,
                zoom: 18.00
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
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     // color: Colors.red,
            //       height: 60,
            //       width: 60,
            //       margin: EdgeInsets.only(top: 10.0,right: 10.0),
            //       child: CircleAvatar(
            //         backgroundColor: mangoBlue,
            //         child: Center(
            //             child: IconButton(
            //               icon: Icon(
            //                 Icons.local_grocery_store,
            //                 size: 30,
            //                 color: Colors.white,
            //               ),
            //               onPressed:(){
            //                 setState(() {
            //                   BlocProvider.of<GetNearbyCompaniesBloc>(context).add(
            //                       GetNearbyCompanies(
            //                         latitude: 6.767930,
            //                     longitude: 79.893264,
            //                     distance: 10000.00
            //                           /*latitude: _myLatitude,
            //                           longitude: _myLongitude,
            //                           distance: 10000.00*/
            //                       ));
            //                 });
            //               },
            //             )),
            //       )
            //
            //   ),
            // ),
            /*Container(
              margin: EdgeInsets.only(top: _size.height*0.5),
              height: 50.0,
              width: 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_myLatitude.toString()),
                  Text("   "),
                  Text(_myLongitude.toString()),
                ],
              ),
            ),*/
          ],
        );
      }
    );
  }

}
