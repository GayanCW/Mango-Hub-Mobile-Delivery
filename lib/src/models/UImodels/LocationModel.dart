import 'package:cloud_firestore/cloud_firestore.dart';

class UserLocation{

  final double longitude;
  final double latitude;

  UserLocation({this.latitude = 0.00,this.longitude=0.00});

}

class MyLocation{

  double longitude;
  double latitude;

  MyLocation({this.latitude = 0.00,this.longitude=0.00});

  MyLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

}


class AllOrderCompanyIds{
  final String sIds;
  AllOrderCompanyIds({this.sIds});

  /*AllOrderCompanyIds.fromSnapshot(DocumentSnapshot snapshot)
      : sId = snapshot['sId'];*/
}