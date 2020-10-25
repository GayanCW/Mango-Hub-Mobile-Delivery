part of 'edit_user_bloc.dart';

@immutable
abstract class EditUserState {}

class EditUserInitial extends EditUserState {}

class EditUserSuccess extends EditUserState{
  EditUserSuccess(this.editUser);
  EditUserModel editUser;
}

class EditUserFailed extends EditUserState{
  EditUserFailed(this.editUser);
  EditUserModel editUser;
}

class EditUserFailedException extends EditUserState{
  EditUserFailedException(this.errorObject);
  final String errorObject;
}

