part of 'delivery_flow_bloc.dart';

@immutable
abstract class DeliveryFlowEvent {}

class AcceptDelivery extends DeliveryFlowEvent{
  final OrderModel deliveryFlow;
  AcceptDelivery(this.deliveryFlow);
}

class DeliveredOrder extends DeliveryFlowEvent{
  final OrderModel deliveryFlow;
  DeliveredOrder(this.deliveryFlow);
}
