import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/models/UImodels/DriverModel.dart';



class FirebaseServices {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  Stream<List<OrderModel>> getAllOrders() {
      return _fireStoreDataBase.collection('OrderDelivery')
          .snapshots()
          .map((snapShot) => snapShot.documents
          .map((document) => OrderModel.fromJson(document.data()))
          .toList());
  }

  Stream<OrderModel> getAcceptedOrder(String sId) {
    return _fireStoreDataBase.collection('OrderDelivery')
        .document(sId)
        .snapshots()
        .map((document) => OrderModel.fromJson(document.data()));
  }

  addDriver( String orderCustomerId, String driverGeo, String driverSpeed)async{

      // String _userProfileId = await _repository.readData('userProfileId');
      DriverModel _driverModel = new DriverModel.fromJson(
         {
            "driver_geo": driverGeo,
            "driver_speed": driverSpeed
          }
      );

      return _fireStoreDataBase.collection('Drivers').document(
            orderCustomerId).setData(_driverModel.toJson());

  }

}

class GeoLocationServices {

  Stream<Position> getMyLiveLocation(){
    return GeolocatorPlatform.instance.getPositionStream(timeInterval: 10000);
  }

  Stream<Position> getMyLiveLocationDistance(){
    return GeolocatorPlatform.instance.getPositionStream(distanceFilter: 10);
  }

}

