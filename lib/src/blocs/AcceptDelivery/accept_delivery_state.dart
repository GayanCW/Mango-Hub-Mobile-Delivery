part of 'accept_delivery_bloc.dart';

@immutable
abstract class AcceptDeliveryState {}

class AcceptDeliveryInitial extends AcceptDeliveryState {}


class AcceptDeliverySuccess extends AcceptDeliveryState{
  AcceptDeliverySuccess(this.response);
  final String response;
}

class AcceptDeliveryFailed extends AcceptDeliveryState{
  AcceptDeliveryFailed(this.response);
  final String response;
}

class AcceptDeliveryFailedException extends AcceptDeliveryState{
  AcceptDeliveryFailedException(this.errorObject);
  final String errorObject;
}
