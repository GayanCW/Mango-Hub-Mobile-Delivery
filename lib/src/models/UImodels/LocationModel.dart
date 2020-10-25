import 'package:cloud_firestore/cloud_firestore.dart';

class UserLocation{

  final double longitude;
  final double latitude;

  UserLocation({this.latitude = 0.00,this.longitude=0.00});

}


class AllOrderCompanyIds{
  final String sIds;
  AllOrderCompanyIds({this.sIds});

  /*AllOrderCompanyIds.fromSnapshot(DocumentSnapshot snapshot)
      : sId = snapshot['sId'];*/
}