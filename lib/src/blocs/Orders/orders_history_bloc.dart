import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'orders_history_event.dart';
part 'orders_history_state.dart';

class OrdersHistoryBloc extends Bloc<OrdersHistoryEvent, OrdersHistoryState> {
  OrdersHistoryBloc() : super(OrdersHistoryInitial());

  @override
  Stream<OrdersHistoryState> mapEventToState(
    OrdersHistoryEvent event,
  ) async* {
    if(event is GetOrdersHistory){
      yield* _getOrdersHistory(event);
    }
  }

  Stream<OrdersHistoryState> _getOrdersHistory(GetOrdersHistory event) async*{

    final String apiUrl = "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/inventory/deliveryorders?order_delivery_person_id="
        "${event.userProfileId}";

    try{
      final response = await http.get(apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': event.token,
        },
      );


      if(response.statusCode == 200 && response.body!=null){
        var validResponse = jsonDecode(response.body);
        yield GetOrdersHistorySuccess(DeliveryHistoryModel.fromJson(validResponse));
      }else{
        var failedResponse = jsonDecode(response.body);
        yield GetOrdersHistoryFailed( DeliveryHistoryModel.fromJson(failedResponse));
      }
    }
    catch(e){
      String errorObject = e.toString().split(':')[1];
      yield GetOrdersHistoryFailedException(errorObject);
    }

  }
}
