class EditUserModel {
  String sId;
  String userFirstName;
  String userLastName;
  String userImage;
  String userReferenceId;
  bool userReference;
  String userStatusString;
  bool userStatus;
  Null userMobile;
  String createdAt;
  String updatedAt;
  int iV;
  UserAddress userAddress;

  EditUserModel(
      {this.sId,
        this.userFirstName,
        this.userLastName,
        this.userImage,
        this.userReferenceId,
        this.userReference,
        this.userStatusString,
        this.userStatus,
        this.userMobile,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.userAddress});

  EditUserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userImage = json['user_image'];
    userReferenceId = json['user_reference_id'];
    userReference = json['user_reference'];
    userStatusString = json['user_status_string'];
    userStatus = json['user_status'];
    userMobile = json['user_mobile'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    userAddress = json['user_address'] != null
        ? new UserAddress.fromJson(json['user_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_first_name'] = this.userFirstName;
    data['user_last_name'] = this.userLastName;
    data['user_image'] = this.userImage;
    data['user_reference_id'] = this.userReferenceId;
    data['user_reference'] = this.userReference;
    data['user_status_string'] = this.userStatusString;
    data['user_status'] = this.userStatus;
    data['user_mobile'] = this.userMobile;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.userAddress != null) {
      data['user_address'] = this.userAddress.toJson();
    }
    return data;
  }
}

class UserAddress {
  String addressLine1;
  String addressLine2;
  String country;
  String district;
  String city;
  String zipCode;

  UserAddress(
      {this.addressLine1,
        this.addressLine2,
        this.country,
        this.district,
        this.city,
        this.zipCode});

  UserAddress.fromJson(Map<String, dynamic> json) {
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