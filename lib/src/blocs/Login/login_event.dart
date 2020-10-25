part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class GetLoginDetails extends LoginEvent{
  GetLoginDetails({this.email, this.password});

  final String email;
  final String password;
}
