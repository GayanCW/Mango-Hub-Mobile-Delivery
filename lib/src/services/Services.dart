import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mangoHub/src/models/APImodels/AuthenticationModel.dart';

import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/models/UImodels/DriverModel.dart';
import 'package:mangoHub/src/shared/Repository.dart';



class FirebaseServices {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  Repository _repository = new Repository();
  Login login = new Login();
  User user = new User();

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

  addDriver( String orderId, Position locationData, double estimateTime)async{

    String _login = await _repository.readData('login');
    String _user = await _repository.readData('user');

    if(_login!=null) {
      login = Login.fromJson(jsonDecode(_login));
    }
    if(_user!=null) {
      user = User.fromJson(jsonDecode(_user));
    }

      DriverModel _driverModel = new DriverModel.fromJson(
         {
           '_id': orderId,
           'driver_geo': "${locationData.latitude},${locationData.longitude}",
           'driver_speed': locationData.speed.toString(),
           'time_taken': estimateTime.toString(),
           'driver': {
             'driver_id': user.sId,
             'driver_first_name': user.userFirstName,
             'driver_last_name': user.userLastName,
             'driver_image': user.userImage,

             'driver_email': login.loginEmail,
             'driver_mobile': login.loginMobile,
             'driver_role': login.loginRole,

             'driver_address': {
               'address_line1': user.userAddress.addressLine1,
               'address_line2': user.userAddress.addressLine2,
               'country': user.userAddress.country,
               'district': user.userAddress.district,
               'city': user.userAddress.city,
               'zip_code': user.userAddress.zipCode,
             },
             'driver_reference_id': user.userReferenceId,
             'driver_reference': user.userReference,
             'driver_status_string': user.userStatusString,
             'driver_status': user.userStatus
           }
         }
      );

      return _fireStoreDataBase.collection('Drivers').document(
            orderId).setData(_driverModel.toJson());
      // please change (orderCustomerId to order sId) in marketplace APP tracking page
  }

}

class GeoLocationServices {

  Stream<Position> getMyLiveLocation(int _timeInterval, int _distanceFilter){
    return GeolocatorPlatform.instance.getPositionStream(timeInterval: _timeInterval, distanceFilter: _distanceFilter);
  }

}

