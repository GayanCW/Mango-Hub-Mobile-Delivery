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

class GetMyProfile extends AuthenticationEvent {
  GetMyProfile({this.token});
  final String token;
}

class PasswordResetRequest extends AuthenticationEvent {
  PasswordResetRequest({this.email});
  final String email;
}

class PasswordReset extends AuthenticationEvent {
  PasswordReset({this.password, this.token});
  final String password;
  final String token;
}

class ImageUpload extends AuthenticationEvent {
  ImageUpload({this.image});
  final File image;
}


