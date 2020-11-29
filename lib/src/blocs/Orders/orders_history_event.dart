part of 'orders_history_bloc.dart';

@immutable
abstract class OrdersHistoryEvent {}

class GetOrdersHistory extends OrdersHistoryEvent{
  GetOrdersHistory({this.userProfileId, this.token});
  final String userProfileId;
  final String token;
}
