part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class GetLoginUserDetails extends AuthenticationEvent{
  GetLoginUserDetails({this.authentication});
  final Authentication authentication;
}

class GetSignUpUserDetails extends AuthenticationEvent{
  GetSignUpUserDetails({this.authentication});
  final Authentication authentication;
}

class GetUpdateUserDetails extends AuthenticationEvent {
  GetUpdateUserDetails({this.authentication});
  final Authentication authentication;
}

class LogoutUser extends AuthenticationEvent {
  LogoutUser({this.token});
  final String token;
}

class GetMyProfile extends AuthenticationEvent {
  GetMyProfile({this.token});
  final String token;
}
