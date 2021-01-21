import 'package:mangoHub/src/models/APImodels/AuthenticationModel.dart';

class DriverModel {

  String sId;
  String driverGeo;
  String driverSpeed;
  String timeTaken;
  Driver driver;

  DriverModel({this.sId, this.driverGeo, this.driverSpeed, this.timeTaken, this.driver});

  DriverModel.fromJson(Map<String, dynamic> json){
    sId = json['_id'];
    driverGeo = json['driver_geo'];
    driverSpeed = json['driver_speed'];
    timeTaken = json['time_taken'];
    driver = json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['driver_geo'] = this.driverGeo;
    data['driver_speed'] = this.driverSpeed;
    data['time_taken'] = this.timeTaken;
    if (this.driver != null) {
      data['driver'] = this.driver.toJson();
    }
    return data;
  }
}

class Driver {
  String driverId;
  String driverFirstName;
  String driverLastName;
  String driverImage;

  String driverEmail;
  String driverMobile;
  String driverRole;

  UserAddress driverAddress;
  String driverReferenceId;
  dynamic driverReference;
  String driverStatusString;
  bool driverStatus;

  Driver(
      {this.driverId,
        this.driverFirstName,
        this.driverLastName,
        this.driverImage,
        this.driverEmail,
        this.driverMobile,
        this.driverRole,
        this.driverAddress,
        this.driverReferenceId,
        this.driverReference,
        this.driverStatusString,
        this.driverStatus});

  Driver.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    driverFirstName = json['driver_first_name'];
    driverLastName = json['driver_last_name'];
    driverImage = json['driver_image'];

    driverEmail = json['driver_email'];
    driverMobile = json['driver_mobile'];
    driverRole = json['driver_role'];

    driverAddress = json['driver_address'] != null
        ? new UserAddress.fromJson(json['driver_address'])
        : null;
    driverReferenceId = json['driver_reference_id'];
    driverReference = json['driver_reference'];
    driverStatusString = json['driver_status_string'];
    driverStatus = json['driver_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_id'] = this.driverId;
    data['driver_first_name'] = this.driverFirstName;
    data['driver_last_name'] = this.driverLastName;
    data['driver_image'] = this.driverImage;

    data['driver_email'] = this.driverEmail;
    data['driver_mobile'] = this.driverMobile;
    data['driver_role'] = this.driverRole;

    if (this.driverAddress != null) {
      data['driver_address'] = this.driverAddress.toJson();
    }
    data['driver_reference_id'] = this.driverReferenceId;
    data['driver_reference'] = this.driverReference;
    data['driver_status_string'] = this.driverStatusString;
    data['driver_status'] = this.driverStatus;
    return data;
  }
}

class DriverAddress {
  String addressLine1;
  String addressLine2;
  String country;
  String district;
  String city;
  dynamic zipCode;

  DriverAddress(
      {this.addressLine1,
        this.addressLine2,
        this.country,
        this.district,
        this.city,
        this.zipCode});

  DriverAddress.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    country = json['country'];
    district = json['district'];
    city = json['city'];
    zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    data['country'] = this.country;
    data['district'] = this.district;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    return data;
  }
}