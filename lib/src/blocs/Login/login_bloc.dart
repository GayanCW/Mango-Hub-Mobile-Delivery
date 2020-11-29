import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mangoHub/src/models/APImodels/LoginUser.dart';
import 'package:mangoHub/src/shared/Repository.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  Repository repository = Repository();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is GetLoginDetails){
     yield* _getLoginDetails(event);
    }
  }

  Stream<LoginState> _getLoginDetails(GetLoginDetails event) async* {
    final String apiUrl = "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/authentication/login";

    try{
      final response = await http.post(apiUrl, body: {"login_email": event.email, "login_password": event.password});

      if (response.statusCode == 200) {
        var loginResponse = jsonDecode(response.body);
        repository.addValue('token', LoginUser.fromJson(loginResponse).token.toString());
        repository.addValue('userProfileId', LoginUser.fromJson(loginResponse).login.userProfileId.toString());
        yield LoginSuccess(LoginUser.fromJson(loginResponse));
      }
      if (response.statusCode >= 400) {
        var errorResponse = jsonDecode(response.body);
        yield LoginFailed(LoginUser.fromJson(errorResponse));
      }
    } catch(e){
      String errorObject = e.toString().split(':')[1];
      yield LoginFailedException(errorObject);
    }
  }
}
