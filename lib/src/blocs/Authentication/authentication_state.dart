part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

////////////////////////////////////////////////////////////////////////////////
class LoginUserSuccess extends AuthenticationState{
  LoginUserSuccess(this.authentication);
  final Authentication authentication;
}
class LoginUserFailed extends AuthenticationState{
  LoginUserFailed(this.authentication);
  final Authentication authentication;
}
class LoginUserFailedException extends AuthenticationState{
  LoginUserFailedException(this.errorObject);
  final String errorObject;
}
////////////////////////////////////////////////////////////////////////////////
class SignUpUserSuccess extends AuthenticationState{
  SignUpUserSuccess(this.authentication);
  final Authentication authentication;
}
class SignUpUserFailed extends AuthenticationState{
  SignUpUserFailed(this.authentication);
  final Authentication authentication;
}
class SignUpUserFailedException extends AuthenticationState{
  SignUpUserFailedException(this.errorObject);
  final String errorObject;
}
////////////////////////////////////////////////////////////////////////////////
class UpdateUserSuccess extends AuthenticationState{
  UpdateUserSuccess(this.authentication);
  final Authentication authentication;
}
class UpdateUserFailed extends AuthenticationState{
  UpdateUserFailed(this.authentication);
  final Authentication authentication;
}
class UpdateUserFailedException extends AuthenticationState{
  UpdateUserFailedException(this.errorObject);
  final String errorObject;
}
////////////////////////////////////////////////////////////////////////////////
class LogoutUserSuccess extends AuthenticationState{
  LogoutUserSuccess(this.authentication);
  final Authentication authentication;
}
class LogoutUserFailed extends AuthenticationState{
  LogoutUserFailed(this.authentication);
  final Authentication authentication;
}
class LogoutUserFailedException extends AuthenticationState{
  LogoutUserFailedException(this.errorObject);
  final String errorObject;
}
////////////////////////////////////////////////////////////////////////////////
class GetMyProfileSuccess extends AuthenticationState{
  GetMyProfileSuccess(this.authentication);
  final Authentication authentication;
}
class GetMyProfileFailed extends AuthenticationState{
  GetMyProfileFailed(this.authentication);
  final Authentication authentication;
}
class GetMyProfileFailedException extends AuthenticationState{
  GetMyProfileFailedException(this.errorObject);
  final String errorObject;
}
////////////////////////////////////////////////////////////////////////////////
