part of 'orders_history_bloc.dart';

@immutable
abstract class OrdersHistoryState {}

class OrdersHistoryInitial extends OrdersHistoryState {}

class GetOrdersHistorySuccess extends OrdersHistoryState{
  GetOrdersHistorySuccess(this.deliveryHistoryModel);
  final DeliveryHistoryModel deliveryHistoryModel;
}

class GetOrdersHistoryFailed extends OrdersHistoryState{
  GetOrdersHistoryFailed(this.deliveryHistoryModel);
  final DeliveryHistoryModel deliveryHistoryModel;
}

class GetOrdersHistoryFailedException extends OrdersHistoryState{
  GetOrdersHistoryFailedException(this.errorObject);
  final String errorObject;
}
