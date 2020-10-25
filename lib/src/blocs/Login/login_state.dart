part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState{
  LoginSuccess(this.loginUser);
  LoginUser loginUser;
}

class LoginFailed extends LoginState{
  LoginFailed(this.loginUser);
  LoginUser loginUser;
}

class LoginFailedException extends LoginState{
  LoginFailedException(this.errorObject);
  final String errorObject;
}
