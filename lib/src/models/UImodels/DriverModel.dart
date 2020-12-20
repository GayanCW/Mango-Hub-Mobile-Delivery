/*

class DriverModel {

  GeoLocations geoLocations;
  String orderDeliveryPersonId;
  String orderCustomerId;

  DriverModel({this.geoLocations, this.orderDeliveryPersonId, this.orderCustomerId});

  DriverModel.fromJson(Map<String, dynamic> json) {
    geoLocations = json['order_geo'] != null
        ? new GeoLocations.fromJson(json['order_geo'])
        : null;
    orderDeliveryPersonId = json['order_delivery_person_id'];
    orderCustomerId = json['order_customer_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoLocations != null) {
      data['order_geo'] = this.geoLocations.toJson();
    }
    data['order_delivery_person_id'] = this.orderDeliveryPersonId;
    data['order_customer_id'] = this.orderCustomerId;

    return data;
  }
}

class GeoLocations {
  String shop;
  String delivery;
  String driver;

  GeoLocations({this.shop, this.delivery, this.driver});

  GeoLocations.fromJson(Map<String, dynamic> json){
    shop = json['shop'];
    delivery = json['delivery'];
    driver = json['driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop'] = this.shop;
    data['delivery'] = this.delivery;
    data['driver'] = this.driver;
    return data;
  }
}*/


/*class DriverModel {

  DriverLocationData driverLocationData;
  String orderDeliveryPersonId;

  DriverModel({this.driverLocationData, this.orderDeliveryPersonId});

  DriverModel.fromJson(Map<String, dynamic> json) {
    driverLocationData = json['driver_location_data'] != null
        ? new DriverLocationData.fromJson(json['driver_location_data'])
        : null;
    orderDeliveryPersonId = json['order_delivery_person_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.driverLocationData != null) {
      data['driver_location_data'] = this.driverLocationData.toJson();
    }
    data['order_delivery_person_id'] = this.orderDeliveryPersonId;
    return data;
  }
}

class DriverLocationData {

  String driverGeo;
  String driverSpeed;
  DriverLocationData({this.driverGeo, this.driverSpeed});

  DriverLocationData.fromJson(Map<String, dynamic> json){
    driverGeo = json['driver_geo'];
    driverSpeed = json['driver_speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_geo'] = this.driverGeo;
    data['driver_speed'] = this.driverSpeed;
    return data;
  }
} */

class DriverModel {

  String driverGeo;
  String driverSpeed;
  DriverModel({this.driverGeo, this.driverSpeed});

  DriverModel.fromJson(Map<String, dynamic> json){
    driverGeo = json['driver_geo'];
    driverSpeed = json['driver_speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_geo'] = this.driverGeo;
    data['driver_speed'] = this.driverSpeed;
    return data;
  }
}