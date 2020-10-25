import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mangoHub/src/models/APImodels/EditUserModel.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc() : super(EditUserInitial());

  @override
  Stream<EditUserState> mapEventToState(
    EditUserEvent event,
  ) async* {
    if(event is GetEditUserDetails){
      yield* _getEditUserDetails(event);
    }
  }

  Stream<EditUserState> _getEditUserDetails(GetEditUserDetails event)async*{
    final String apiUrl = "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/authentication/user";

    try{
      final response = await http.put(apiUrl,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZjgxNTZlYjkxYzFhMDA2NGI3NGUxN2IiLCJpYXQiOjE2MDIzMTIxMjAzMTEsImV4cCI6MTYwMjMxMjIwNjcxMX0.tKN5NYrN2IWZp9H-PwpIHuyTx9iylmHAHxpQWAkqoWOlYpPqn2_uicNNYHEP0Pnqet1jU273HJX63lJRyhSwKorg-cK0DiAnF6JMnAuNaDEdgMCS_IMjeQt5MCUH5bipBUqe4jlNolO8vciq8WKbFP-uUxnXj91FCtKhKugUSZi-AqyWEvyBzqVv9NZd4OGOHsgeaB1cYrNJfIhQ28actUW-e0huUGGQNj8JGfU3JxRAJO3rgZXMDRLV6Istr_AlnOoQBys3bhEIdLvjDlMW_J67fJptIHbdaaRMxqHV-Y19GjdI4KJu3i2xQvslqvyDR3obTdQfk0Rc70afLsmprD1AP80oxul-JRH_HPk1-6XLISGBZCD1zBfViHXG0pWqMn_ieXPz3SI3yp-XHUn7ODrH74PmPsJV14Es0gLep0EWCISdITSA9OCeL1C75Vr8GV-Fh2TShMtJqi9O3dJyRcskZCraz3bIRXXYCfJsw3XRUraBEP6Qjbm7ZWAkUCGXffZJgQ0sjXDygFA0v3EgJi7WCOIQWhV5URD6jxKjPYnJrnl02e38sNcPai_GoldsWBK_uu-Ie6L6Z8V0e9ZR6W3wDjI4I1PVcLbyIRHrwLbEfyaYuxuPagJVskAuvP8bYV3FABqJdz4v_hFepUx68mJG9TvPGkj6Mu295TQm8y0"
        },
        body: jsonEncode(<String, dynamic>{
          "_id": event.id, //user_profile_id
          "user_first_name": event.userFirstName,
          "user_last_name": event.userLastName,
          "user_image": event.userImage,
          "user_address" : {
            "address_line1" : event.userAddress.addressLine1,
            "address_line2" : event.userAddress.addressLine2,
            "country" : event.userAddress.country,
            "district" : event.userAddress.district,
            "city" : event.userAddress.city,
            "zip_code" : event.userAddress.zipCode
          },
          "user_reference_id": "123",
          "user_reference": true,
          "user_status_string": "pending",
          "user_status": true
        }));

      if (response.statusCode == 200) {
        var editUserResponse = jsonDecode(response.body);
        yield EditUserSuccess(EditUserModel.fromJson(editUserResponse));
      }
      if (response.statusCode >= 400) {
        var errorResponse = jsonDecode(response.body);
        yield EditUserFailed(EditUserModel.fromJson(errorResponse));
      }

    }catch (e) {
      print(e);
      String errorObject = e.toString().split(':')[1];
      yield EditUserFailedException(errorObject);
    }
  }
}
