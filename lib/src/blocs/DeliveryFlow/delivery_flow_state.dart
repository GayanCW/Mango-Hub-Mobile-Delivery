part of 'delivery_flow_bloc.dart';

@immutable
abstract class DeliveryFlowState {}

class DeliveryFlowInitial extends DeliveryFlowState {}

class AcceptedDeliverySuccess extends DeliveryFlowState{
  AcceptedDeliverySuccess(this.response);
  final OrderModel response;
}

class AcceptedDeliveryFailed extends DeliveryFlowState{
  AcceptedDeliveryFailed(this.response);
  final OrderModel response;
}

class AcceptedDeliveryFailedException extends DeliveryFlowState{
  AcceptedDeliveryFailedException(this.errorObject);
  final String errorObject;
}
////////////////////////////////////////////////////////////////////////////////
class DeliveredDeliverySuccess extends DeliveryFlowState{
  DeliveredDeliverySuccess(this.response);
  final OrderModel response;
}

class DeliveredDeliveryFailed extends DeliveryFlowState{
  DeliveredDeliveryFailed(this.response);
  final OrderModel response;
}

class DeliveredDeliveryFailedException extends DeliveryFlowState{
  DeliveredDeliveryFailedException(this.errorObject);
  final String errorObject;
}

