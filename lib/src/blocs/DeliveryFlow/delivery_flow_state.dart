part of 'delivery_flow_bloc.dart';

@immutable
abstract class DeliveryFlowState {}

class DeliveryFlowInitial extends DeliveryFlowState {}

class DeliveryFlowSuccess extends DeliveryFlowState{
  DeliveryFlowSuccess(this.response);
  final String response;
}

class DeliveryFlowFailed extends DeliveryFlowState{
  DeliveryFlowFailed(this.response);
  final String response;
}

class DeliveryFlowFailedException extends DeliveryFlowState{
  DeliveryFlowFailedException(this.errorObject);
  final String errorObject;
}

