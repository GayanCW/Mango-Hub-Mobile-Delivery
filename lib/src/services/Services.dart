import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'file:///G:/MangoHub/mangohub-mobile-delivery/lib/src/models/UImodels/DriverModel.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/shared/Repository.dart';

class FirebaseServices {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  Repository _repository = new Repository();


  //recieve the data

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
        .map((event) => OrderModel.fromJson(event.data()));
  }

  //upload a data
  /*addUser(){
    var addUserData = Map<String,dynamic>();
    addUserData['name'] = "Gayan Chanaka";
    addUserData['age'] = "25yrs";
    return _fireStoreDataBase.collection('User').document('user_01').setData(addUserData);
  }*/

  addDriver( String orderCustomerId,String shop, String delivery, String driver)async{

      String _userProfileId = await _repository.readData('userProfileId');
      DriverModel _driverModel = new DriverModel.fromJson(
          {
            "order_customer_id": orderCustomerId,
            "order_delivery_person_id": _userProfileId,
            "order_geo": {
              "shop": shop,
              "delivery": delivery,
              "driver": driver
            }
          }
      );

      Future.delayed(const Duration(seconds: 10), (){
        print('time passing');
        return _fireStoreDataBase.collection('Drivers').document(
            _driverModel.orderCustomerId).setData(_driverModel.toJson());
      });

  }

}

class LocationService {

  Location location = Location();

  StreamController<UserLocation> _locationController = StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService(){

    location.onLocationChanged.listen((locationData) {
      if (locationData != null) {
        _locationController.add(UserLocation(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
          speed: locationData.speed
        ));
      }
    });
  }
}

class UserLocation {

  final double longitude;
  final double latitude;
  final double speed;

  UserLocation({this.latitude = 0.00,this.longitude=0.00, this.speed});

}