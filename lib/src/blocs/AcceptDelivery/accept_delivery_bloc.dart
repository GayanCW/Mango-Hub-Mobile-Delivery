import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mangoHub/src/shared/Repository.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'accept_delivery_event.dart';
part 'accept_delivery_state.dart';

class AcceptDeliveryBloc extends Bloc<AcceptDeliveryEvent, AcceptDeliveryState> {
  AcceptDeliveryBloc() : super(AcceptDeliveryInitial());

  Repository repository = new Repository();

  @override
  Stream<AcceptDeliveryState> mapEventToState(
    AcceptDeliveryEvent event,
  ) async* {
    if(event is AcceptDelivery){
      yield* _acceptDelivery(event);
    }
  }

  Stream<AcceptDeliveryState> _acceptDelivery(AcceptDelivery event) async*{
    final String apiUrl = "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/inventory/acceptOrderDelivery";
    String token = await repository.readData('token');
    try{
      final response = await http.put(apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
          'comp_id': event.orderCompany     
        },
          body: jsonEncode(<String, dynamic>{
              "order_geo": {
                "shop": event.orderGeo.shop,
                "delivery": event.orderGeo.delivery
              },
              "order_product_list": event.orderProductList,
              "order_aditional_charges": event.orderAdditionalCharges,
              "_id": event.sId,
              "order_date": event.orderDate,
              "order_company": event.orderCompany,
              "order_branch_id": event.orderBranchId,
              "order_customer_id": event.orderCustomerId,
              "order_customer_name": event.orderCustomerName,
              "order_customer_mobile": event.orderCustomerMobile,
              "order_payment_method": event.orderPaymentMethod,
              "order_amount": event.orderAmount,
              "order_discount": event.orderDiscount,
              "order_total": event.orderTotal,
              "order_status": event.orderStatus,
              "order_status_string": event.orderStatusString,
              "order_type": event.orderType,
              "order_accepted_user_id": event.orderAcceptedUserId,
              "order_invoice_id": event.orderInvoiceId,
              "order_delivery_person_id": event.orderDeliveryPersonId // need to change
          }
        )
      );

      if(response.statusCode == 200){
        yield AcceptDeliverySuccess('Success');
      }else{
        yield AcceptDeliveryFailed('Failed');
      }
    }
    catch(e){
      String errorObject = e.toString().split(':')[1];
      yield AcceptDeliveryFailedException(errorObject);
    }

  }
}
