import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mangoHub/src/models/APImodels/SignUpUser.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'signUp_event.dart';

part 'signUp_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial());

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is GetSignUpDetails) {
      yield* _getSignUpDetails(event);
    }
  }

  Stream<SignUpState> _getSignUpDetails(GetSignUpDetails event) async* {
    final String apiUrl =
        "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/authentication/register";

    try {
      final response = await http.post(apiUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "login": {
              "login_email": event.login.loginEmail,
              "login_password": event.login.loginPassword,
              "login_type": event.login.loginType,
              "login_role": event.login.loginRole,
              "login_status": event.login.loginStatus,
              "login_status_string":  event.login.loginStatusString,
              "login_companies": event.login.loginCompanies,
              "user_profile_id":  event.login.userProfileId
            },
            "user": {
              "user_first_name": event.user.userFirstName,
              "user_last_name": event.user.userLastName,
              "user_image": event.user.userImage,
              "user_address":{
                "address_line1":  event.user.userAddress.addressLine1,
                "address_line2":  event.user.userAddress.addressLine2,
                "country":  event.user.userAddress.country,
                "district": event.user.userAddress.district,
                "city": event.user.userAddress.city,
                "zip_code": event.user.userAddress.zipCode
              },
              "user_reference_id": event.user.userReferenceId,
              "user_reference": event.user.userReference,
              "user_status_string": event.user.userStatusString,
              "user_status":  event.user.userStatus,
              "user_mobile":  event.user.userMobile

            }
          }));

      if (response.statusCode == 200) {
        var signUpResponse = jsonDecode(response.body);
        yield SignUpSuccess(SignUpUser.fromJson(signUpResponse));
      }
      if (response.statusCode >= 400) {
        var errorResponse = jsonDecode(response.body);
        yield SignUpFailed(SignUpUser.fromJson(errorResponse));
      }
    } catch (e) {
      print(e);
      String errorObject = e.toString().split(':')[1];
      yield SignUpFailedException(errorObject);
    }
  }
}
