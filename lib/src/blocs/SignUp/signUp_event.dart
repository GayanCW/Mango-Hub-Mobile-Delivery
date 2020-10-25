part of 'signUp_bloc.dart';

@immutable
abstract class SignUpEvent {}

// ignore: must_be_immutable
class GetSignUpDetails extends SignUpEvent{

  GetSignUpDetails({this.login,this.user});
  LoginUser login;
  User user;


}

class LoginUser{
  LoginUser({this.loginEmail,this.loginPassword,this.loginType,this.loginRole,this.loginStatus,this.loginStatusString,this.loginCompanies,this.userProfileId});

  String loginEmail;
  String loginPassword;
  String loginType;
  String loginRole;
  bool loginStatus;
  String loginStatusString;
  List<dynamic> loginCompanies;
  String userProfileId;
}

class User{
  User({this.userFirstName,this.userLastName,this.userImage, this.userAddress,this.userReferenceId,this.userReference,this.userStatusString,this.userStatus,this.userMobile});
  String userFirstName;
  String userLastName;
  String userImage;
  UserAddress userAddress;

  String userReferenceId;
  bool userReference;
  String userStatusString;
  bool userStatus;
  String userMobile;
}

class UserAddress{
  UserAddress({this.addressLine1,this.addressLine2,this.country,this.district,this.city,this.zipCode});
  String addressLine1;
  String addressLine2;
  String country;
  String district;
  String city;
  String zipCode;
}