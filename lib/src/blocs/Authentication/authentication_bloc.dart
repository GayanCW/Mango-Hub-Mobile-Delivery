import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mangoHub/src/models/APImodels/AuthenticationModel.dart';
import 'package:mangoHub/src/shared/Repository.dart';
import 'package:mangoHub/src/shared/GlobalData.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());
  Repository _repository = Repository();


  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if(event is GetLoginUserDetails){
      yield* _getLoginUserDetails(event);
    }
    if (event is GetSignUpUserDetails) {
      yield* _getSignUpUserDetails(event);
    }
    if(event is GetUpdateUserDetails){
      yield* _getUpdateUserDetails(event);
    }
    if(event is LogoutUser){
      yield* _logoutUser(event);
    }
    if(event is GetMyProfile){
      yield* _getMyProfile(event);
    }

  }

  Stream<AuthenticationState> _getLoginUserDetails(GetLoginUserDetails event) async* {

    try{
      final response = await http.post(mainPath+"/authentication/login", body: {"login_user_name": event.authentication.login.loginUserName, "login_password": event.authentication.login.loginPassword, "login_uid": event.authentication.login.loginUid});

      if (response.statusCode == 200) {
        var loginResponse = jsonDecode(response.body);
        _repository.addValue('token', Authentication.fromJson(loginResponse).token.toString());
        _repository.addValue('userProfileId', Authentication.fromJson(loginResponse).login.userProfileId.toString());
        _repository.addValue('login', jsonEncode(Authentication.fromJson(loginResponse).login).toString());

        yield LoginUserSuccess(Authentication.fromJson(loginResponse));
      }
      if (response.statusCode >= 400) {
        var errorResponse = jsonDecode(response.body);
        yield LoginUserFailed(Authentication.fromJson(errorResponse));
      }
    } catch(e){
      String errorObject = e.toString().split(':')[1];
      yield LoginUserFailedException(errorObject);
    }
  }

  Stream<AuthenticationState> _getSignUpUserDetails(GetSignUpUserDetails event) async* {
    try {
      final response = await http.post(mainPath+"/authentication/register",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "login": {
              "login_email": event.authentication.login.loginEmail,
              "login_email_verification": event.authentication.login.loginEmailVerification,
              "login_mobile": event.authentication.login.loginMobile,
              "login_mobile_verification": event.authentication.login.loginMobileVerification,
              "login_password": event.authentication.login.loginPassword,
              "login_type": event.authentication.login.loginType,
              "login_role": event.authentication.login.loginRole,
              "login_status": event.authentication.login.loginStatus,
              "login_status_string":  event.authentication.login.loginStatusString,
              "login_companies": event.authentication.login.loginCompanies,
              "login_uid": event.authentication.login.loginUid,
              "user_profile_id":  event.authentication.login.userProfileId
            },

            "user": {
              "user_first_name": event.authentication.user.userFirstName,
              "user_last_name": event.authentication.user.userLastName,
              "user_image": event.authentication.user.userImage,
              "user_address":{
                "address_line1":  event.authentication.user.userAddress.addressLine1,
                "address_line2":  event.authentication.user.userAddress.addressLine2,
                "country":  event.authentication.user.userAddress.country,
                "district": event.authentication.user.userAddress.district,
                "city": event.authentication.user.userAddress.city,
                "zip_code": event.authentication.user.userAddress.zipCode
              },
              "user_reference_id": event.authentication.user.userReferenceId,
              "user_reference": event.authentication.user.userReference,
              "user_status_string": event.authentication.user.userStatusString,
              "user_status":  event.authentication.user.userStatus,
            }
          }));

      if (response.statusCode == 200) {
        var signUpResponse = jsonDecode(response.body);
        yield SignUpUserSuccess(Authentication.fromJson(signUpResponse));
      }
      if (response.statusCode >= 400) {
        var errorResponse = jsonDecode(response.body);
        yield SignUpUserFailed(Authentication.fromJson(errorResponse));
      }
    } catch (e) {
      print(e);
      String errorObject = e.toString().split(':')[1];
      yield SignUpUserFailedException(errorObject);
    }
  }

  Stream<AuthenticationState> _getUpdateUserDetails(GetUpdateUserDetails event)async*{

    try{
      final response = await http.put(editUserUrl,
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            // "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZjgxNTZlYjkxYzFhMDA2NGI3NGUxN2IiLCJpYXQiOjE2MDIzMTIxMjAzMTEsImV4cCI6MTYwMjMxMjIwNjcxMX0.tKN5NYrN2IWZp9H-PwpIHuyTx9iylmHAHxpQWAkqoWOlYpPqn2_uicNNYHEP0Pnqet1jU273HJX63lJRyhSwKorg-cK0DiAnF6JMnAuNaDEdgMCS_IMjeQt5MCUH5bipBUqe4jlNolO8vciq8WKbFP-uUxnXj91FCtKhKugUSZi-AqyWEvyBzqVv9NZd4OGOHsgeaB1cYrNJfIhQ28actUW-e0huUGGQNj8JGfU3JxRAJO3rgZXMDRLV6Istr_AlnOoQBys3bhEIdLvjDlMW_J67fJptIHbdaaRMxqHV-Y19GjdI4KJu3i2xQvslqvyDR3obTdQfk0Rc70afLsmprD1AP80oxul-JRH_HPk1-6XLISGBZCD1zBfViHXG0pWqMn_ieXPz3SI3yp-XHUn7ODrH74PmPsJV14Es0gLep0EWCISdITSA9OCeL1C75Vr8GV-Fh2TShMtJqi9O3dJyRcskZCraz3bIRXXYCfJsw3XRUraBEP6Qjbm7ZWAkUCGXffZJgQ0sjXDygFA0v3EgJi7WCOIQWhV5URD6jxKjPYnJrnl02e38sNcPai_GoldsWBK_uu-Ie6L6Z8V0e9ZR6W3wDjI4I1PVcLbyIRHrwLbEfyaYuxuPagJVskAuvP8bYV3FABqJdz4v_hFepUx68mJG9TvPGkj6Mu295TQm8y0"
            "Authorization": event.authentication.token
          },
          body: jsonEncode(<String, dynamic>{
            "_id": event.authentication.login.userProfileId, //user_profile_id
            "user_first_name": event.authentication.user.userFirstName,
            "user_last_name": event.authentication.user.userLastName,
            "user_image": event.authentication.user.userImage,
            "user_address" : {
              "address_line1" : event.authentication.user.userAddress.addressLine1,
              "address_line2" : event.authentication.user.userAddress.addressLine2,
              "country" : event.authentication.user.userAddress.country,
              "district" : event.authentication.user.userAddress.district,
              "city" : event.authentication.user.userAddress.city,
              "zip_code" : event.authentication.user.userAddress.zipCode
            },
            "user_reference_id": "123",
            "user_reference": true,
            "user_status_string": "pending",
            "user_status": true
          }));

      if (response.statusCode == 200) {
        var editUserResponse = jsonDecode(response.body);
        yield UpdateUserSuccess(Authentication.fromJson(editUserResponse));
      }
      if (response.statusCode >= 400) {
        var errorResponse = jsonDecode(response.body);
        yield UpdateUserFailed(Authentication.fromJson(errorResponse));
      }

    }catch (e) {
      print(e);
      String errorObject = e.toString().split(':')[1];
      yield UpdateUserFailedException(errorObject);
    }
  }

  Stream<AuthenticationState> _logoutUser(LogoutUser event)async*{

    try{
      final response = await http.post(mainPath+"/authentication/logout",
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            // "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZjgxNTZlYjkxYzFhMDA2NGI3NGUxN2IiLCJpYXQiOjE2MDIzMTIxMjAzMTEsImV4cCI6MTYwMjMxMjIwNjcxMX0.tKN5NYrN2IWZp9H-PwpIHuyTx9iylmHAHxpQWAkqoWOlYpPqn2_uicNNYHEP0Pnqet1jU273HJX63lJRyhSwKorg-cK0DiAnF6JMnAuNaDEdgMCS_IMjeQt5MCUH5bipBUqe4jlNolO8vciq8WKbFP-uUxnXj91FCtKhKugUSZi-AqyWEvyBzqVv9NZd4OGOHsgeaB1cYrNJfIhQ28actUW-e0huUGGQNj8JGfU3JxRAJO3rgZXMDRLV6Istr_AlnOoQBys3bhEIdLvjDlMW_J67fJptIHbdaaRMxqHV-Y19GjdI4KJu3i2xQvslqvyDR3obTdQfk0Rc70afLsmprD1AP80oxul-JRH_HPk1-6XLISGBZCD1zBfViHXG0pWqMn_ieXPz3SI3yp-XHUn7ODrH74PmPsJV14Es0gLep0EWCISdITSA9OCeL1C75Vr8GV-Fh2TShMtJqi9O3dJyRcskZCraz3bIRXXYCfJsw3XRUraBEP6Qjbm7ZWAkUCGXffZJgQ0sjXDygFA0v3EgJi7WCOIQWhV5URD6jxKjPYnJrnl02e38sNcPai_GoldsWBK_uu-Ie6L6Z8V0e9ZR6W3wDjI4I1PVcLbyIRHrwLbEfyaYuxuPagJVskAuvP8bYV3FABqJdz4v_hFepUx68mJG9TvPGkj6Mu295TQm8y0"
            "Authorization": event.token
          },);

      if (response.statusCode == 200) {
        var logoutUserResponse = jsonDecode(response.body);
        yield UpdateUserSuccess(Authentication.fromJson(logoutUserResponse));
      }
      if (response.statusCode >= 400) {
        var errorResponse = jsonDecode(response.body);
        yield UpdateUserFailed(Authentication.fromJson(errorResponse));
      }

    }catch (e) {
      print(e);
      String errorObject = e.toString().split(':')[1];
      yield UpdateUserFailedException(errorObject);
    }
  }

  Stream<AuthenticationState> _getMyProfile(GetMyProfile event)async*{

    try{
      final response = await http.get(mainPath+"/authentication/me",
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          // "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZjgxNTZlYjkxYzFhMDA2NGI3NGUxN2IiLCJpYXQiOjE2MDIzMTIxMjAzMTEsImV4cCI6MTYwMjMxMjIwNjcxMX0.tKN5NYrN2IWZp9H-PwpIHuyTx9iylmHAHxpQWAkqoWOlYpPqn2_uicNNYHEP0Pnqet1jU273HJX63lJRyhSwKorg-cK0DiAnF6JMnAuNaDEdgMCS_IMjeQt5MCUH5bipBUqe4jlNolO8vciq8WKbFP-uUxnXj91FCtKhKugUSZi-AqyWEvyBzqVv9NZd4OGOHsgeaB1cYrNJfIhQ28actUW-e0huUGGQNj8JGfU3JxRAJO3rgZXMDRLV6Istr_AlnOoQBys3bhEIdLvjDlMW_J67fJptIHbdaaRMxqHV-Y19GjdI4KJu3i2xQvslqvyDR3obTdQfk0Rc70afLsmprD1AP80oxul-JRH_HPk1-6XLISGBZCD1zBfViHXG0pWqMn_ieXPz3SI3yp-XHUn7ODrH74PmPsJV14Es0gLep0EWCISdITSA9OCeL1C75Vr8GV-Fh2TShMtJqi9O3dJyRcskZCraz3bIRXXYCfJsw3XRUraBEP6Qjbm7ZWAkUCGXffZJgQ0sjXDygFA0v3EgJi7WCOIQWhV5URD6jxKjPYnJrnl02e38sNcPai_GoldsWBK_uu-Ie6L6Z8V0e9ZR6W3wDjI4I1PVcLbyIRHrwLbEfyaYuxuPagJVskAuvP8bYV3FABqJdz4v_hFepUx68mJG9TvPGkj6Mu295TQm8y0"
          "Authorization": event.token
        },);

      if (response.statusCode == 200) {
        var getMyProfileResponse = jsonDecode(response.body);
        _repository.addValue('user', jsonEncode(Authentication.fromJson({'user' : getMyProfileResponse}).user).toString());
        yield GetMyProfileSuccess(Authentication.fromJson({'user' : getMyProfileResponse}));
      }
      if (response.statusCode >= 400) {
        var errorResponse = jsonDecode(response.body);
        yield GetMyProfileFailed(Authentication.fromJson(errorResponse));
      }

    }catch (e) {
      print(e);
      String errorObject = e.toString().split(':')[1];
      yield GetMyProfileFailedException(errorObject);
    }
  }

}

