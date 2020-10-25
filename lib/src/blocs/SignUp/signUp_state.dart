part of 'signUp_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpSuccess extends SignUpState{
  SignUpSuccess(this.signUpUser);
  SignUpUser signUpUser;
}

class SignUpFailed extends SignUpState{
  SignUpFailed(this.signUpUser);
  SignUpUser signUpUser;
}

class SignUpFailedException extends SignUpState{
  SignUpFailedException(this.errorObject);
  final String errorObject;
}
