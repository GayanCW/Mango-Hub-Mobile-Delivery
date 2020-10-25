part of 'edit_user_bloc.dart';

@immutable
abstract class EditUserEvent {}

// ignore: must_be_immutable
class GetEditUserDetails extends EditUserEvent {
  GetEditUserDetails(
      {this.id,
      this.userFirstName,
      this.userLastName,
      this.userImage,
      this.userAddress,
      this.userReferenceId,
      this.userReference,
      this.userStatusString,
      this.userStatus});

  String id;
  String userFirstName;
  String userLastName;
  String userImage;
  UserAddress userAddress;
  String userReferenceId;
  bool userReference;
  String userStatusString;
  bool userStatus;
}

class UserAddress {
  UserAddress(
      {this.addressLine1,
      this.addressLine2,
      this.country,
      this.district,
      this.city,
      this.zipCode});

  String addressLine1;
  String addressLine2;
  String country;
  String district;
  String city;
  String zipCode;
}
