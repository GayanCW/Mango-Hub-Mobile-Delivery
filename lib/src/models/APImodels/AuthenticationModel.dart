List<Authentication> profileDetails = new List<Authentication>();

class Authentication {
  bool success;
  bool exist;
  String token;
  String expiresIn;
  String msg;
  String message;
  Login login;
  User user;

  Authentication({this.success, this.exist, this.token, this.expiresIn, this.msg,this.message, this.login, this.user});

  Authentication.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    exist = json['exist'];
    token = json['token'];
    expiresIn = json['expiresIn'];
    msg = json['msg'];
    message = json['message'];
    login = json['login'] != null ? new Login.fromJson(json['login']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['exist'] = this.exist;
    data['token'] = this.token;
    data['expiresIn'] = this.expiresIn;
    data['msg'] = this.msg;
    data['message'] = this.message;
    if (this.login != null) {
      data['login'] = this.login.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Login {
  String sId;
  String loginEmail;
  String loginUserName;
  bool loginEmailVerification;
  String loginMobile;
  bool loginMobileVerification;
  String loginPassword;
  String loginSalt;
  String loginType;
  String loginRole;
  dynamic loginStatus;
  String loginStatusString;
  List<String> loginCompanies;
  String loginUid;
  String userProfileId;
  int iV;

  Login(
      { this.sId,
        this.loginEmail,
        this.loginUserName,
        this.loginEmailVerification,
        this.loginMobile,
        this.loginMobileVerification,
        this.loginPassword,
        this.loginSalt,
        this.loginType,
        this.loginRole,
        this.loginStatus,
        this.loginStatusString,
        this.loginCompanies,
        this.loginUid,
        this.userProfileId,
        this.iV}
  );

  Login.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    loginEmail = json['login_email'];
    loginUserName = json['login_user_name'];
    loginEmailVerification = json['login_email_verification'];
    loginMobile = json['login_mobile'];
    loginMobileVerification = json['login_mobile_verification'];
    loginPassword = json['login_password'];
    loginSalt = json['login_salt'];
    loginType = json['login_type'];
    loginRole = json['login_role'];
    loginStatus = json['login_status'];
    loginStatusString = json['login_status_string'];
    loginCompanies = json['login_companies'].cast<String>();
    loginUid = json['login_uid'];
    userProfileId = json['user_profile_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['login_email'] = this.loginEmail;
    data['login_user_name'] = this.loginUserName;
    data['login_email_verification'] = this.loginEmailVerification;
    data['login_mobile'] = this.loginMobile;
    data['login_mobile_verification'] = this.loginMobileVerification;
    data['login_password'] = this.loginPassword;
    data['login_salt'] = this.loginSalt;
    data['login_type'] = this.loginType;
    data['login_role'] = this.loginRole;
    data['login_status'] = this.loginStatus;
    data['login_status_string'] = this.loginStatusString;
    data['login_companies'] = this.loginCompanies;
    data['login_uid'] = this.loginUid;
    data['user_profile_id'] = this.userProfileId;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  String sId;
  String userFirstName;
  String userLastName;
  String userImage;
  UserAddress userAddress;
  String userReferenceId;
  dynamic userReference;
  String userStatusString;
  bool userStatus;

  User(
      {this.sId,
        this.userFirstName,
        this.userLastName,
        this.userImage,
        this.userAddress,
        this.userReferenceId,
        this.userReference,
        this.userStatusString,
        this.userStatus});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userImage = json['user_image'];
    userAddress = json['user_address'] != null
        ? new UserAddress.fromJson(json['user_address'])
        : null;
    userReferenceId = json['user_reference_id'];
    userReference = json['user_reference'];
    userStatusString = json['user_status_string'];
    userStatus = json['user_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_first_name'] = this.userFirstName;
    data['user_last_name'] = this.userLastName;
    data['user_image'] = this.userImage;
    if (this.userAddress != null) {
      data['user_address'] = this.userAddress.toJson();
    }
    data['user_reference_id'] = this.userReferenceId;
    data['user_reference'] = this.userReference;
    data['user_status_string'] = this.userStatusString;
    data['user_status'] = this.userStatus;
    return data;
  }
}

class UserAddress {
  String addressLine1;
  String addressLine2;
  String country;
  String district;
  String city;
  dynamic zipCode;

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