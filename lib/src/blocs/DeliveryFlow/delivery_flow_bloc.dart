import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:mangoHub/src/shared/Repository.dart';

part 'delivery_flow_event.dart';
part 'delivery_flow_state.dart';

class DeliveryFlowBloc extends Bloc<DeliveryFlowEvent, DeliveryFlowState> {
  DeliveryFlowBloc() : super(DeliveryFlowInitial());
  Repository repository = new Repository();
  DeliveryFlow deliveryFlow = new DeliveryFlow();

  @override
  Stream<DeliveryFlowState> mapEventToState(DeliveryFlowEvent event) async* {
    if (event is AcceptDelivery) {
      yield* _acceptDelivery(event);
    }
    if (event is HandoverOrder) {
      yield* _handoverOrder(event);
    }
    if (event is DeliveredOrder) {
      yield* _deliveredOrder(event);
    }
  }

  Stream<DeliveryFlowState> _acceptDelivery(AcceptDelivery event) async* {
    final String apiUrl = "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/inventory/acceptOrderDelivery";
    String token = await repository.readData('token');
    try {
      final response = await http.put(apiUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
            'comp_id': event.deliveryFlow.orderCompany
          },
          body: jsonEncode(<String, dynamic>{
            "order_geo": {
              "shop": event.deliveryFlow.orderGeo.shop,
              "delivery": event.deliveryFlow.orderGeo.delivery
            },
            "order_product_list": event.deliveryFlow.orderProductList,
            "order_aditional_charges": event.deliveryFlow.orderAdditionalCharges,
            "_id": event.deliveryFlow.sId,
            "order_date": event.deliveryFlow.orderDate,
            "order_company": event.deliveryFlow.orderCompany,
            "order_branch_id": event.deliveryFlow.orderBranchId,
            "order_customer_id": event.deliveryFlow.orderCustomerId,
            "order_customer_name": event.deliveryFlow.orderCustomerName,
            "order_customer_mobile": event.deliveryFlow.orderCustomerMobile,
            "order_payment_method": event.deliveryFlow.orderPaymentMethod,
            "order_amount": event.deliveryFlow.orderAmount,
            "order_discount": event.deliveryFlow.orderDiscount,
            "order_total": event.deliveryFlow.orderTotal,
            "order_status": event.deliveryFlow.orderStatus,
            "order_status_string": event.deliveryFlow.orderStatusString,
            "order_type": event.deliveryFlow.orderType,
            "order_accepted_user_id": event.deliveryFlow.orderAcceptedUserId,
            "order_invoice_id": event.deliveryFlow.orderInvoiceId,
            "order_delivery_person_id": event.deliveryFlow.orderDeliveryPersonId
            // need to change
          }
          )
      );

      if (response.statusCode == 200) {
        yield DeliveryFlowSuccess('Success');
      } else {
        yield DeliveryFlowFailed('Failed');
      }
    }
    catch (e) {
      String errorObject = e.toString().split(':')[1];
      yield DeliveryFlowFailedException(errorObject);
    }
  }

  Stream<DeliveryFlowState> _handoverOrder(HandoverOrder event) async* {
    final String apiUrl = "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/inventory/handoverOrder";
    String token = await repository.readData('token');
    try {
      final response = await http.put(apiUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
            'comp_id': event.deliveryFlow.orderCompany
          },
          body: jsonEncode(<String, dynamic>{
            "order_geo": {
              "shop": event.deliveryFlow.orderGeo.shop,
              "delivery": event.deliveryFlow.orderGeo.delivery
            },
            "order_product_list": event.deliveryFlow.orderProductList,
            "order_aditional_charges": event.deliveryFlow.orderAdditionalCharges,
            "_id": event.deliveryFlow.sId,
            "order_date": event.deliveryFlow.orderDate,
            "order_company": event.deliveryFlow.orderCompany,
            "order_branch_id": event.deliveryFlow.orderBranchId,
            "order_customer_id": event.deliveryFlow.orderCustomerId,
            "order_customer_name": event.deliveryFlow.orderCustomerName,
            "order_customer_mobile": event.deliveryFlow.orderCustomerMobile,
            "order_payment_method": event.deliveryFlow.orderPaymentMethod,
            "order_amount": event.deliveryFlow.orderAmount,
            "order_discount": event.deliveryFlow.orderDiscount,
            "order_total": event.deliveryFlow.orderTotal,
            "order_status": event.deliveryFlow.orderStatus,
            "order_status_string": event.deliveryFlow.orderStatusString,
            "order_type": event.deliveryFlow.orderType,
            "order_accepted_user_id": event.deliveryFlow.orderAcceptedUserId,
            "order_invoice_id": event.deliveryFlow.orderInvoiceId,
            "order_delivery_person_id": event.deliveryFlow.orderDeliveryPersonId
            // need to change
          }
          )
      );

      if (response.statusCode == 200) {
        yield DeliveryFlowSuccess('Success');
      } else {
        yield DeliveryFlowFailed('Failed');
      }
    }
    catch (e) {
      String errorObject = e.toString().split(':')[1];
      yield DeliveryFlowFailedException(errorObject);
    }
  }

  Stream<DeliveryFlowState> _deliveredOrder(DeliveredOrder event) async* {
    final String apiUrl = "https://app-a5e00a51-0c5e-4dce-a2df-5662105ba7f4.cleverapps.io/inventory/deliveredOrder";
    String token = await repository.readData('token');
    try {
      final response = await http.put(apiUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
            'comp_id': event.deliveryFlow.orderCompany
          },
          body: jsonEncode(<String, dynamic>{
            "order_geo": {
              "shop": event.deliveryFlow.orderGeo.shop,
              "delivery": event.deliveryFlow.orderGeo.delivery
            },
            "order_product_list": event.deliveryFlow.orderProductList,
            "order_aditional_charges": event.deliveryFlow.orderAdditionalCharges,
            "_id": event.deliveryFlow.sId,
            "order_date": event.deliveryFlow.orderDate,
            "order_company": event.deliveryFlow.orderCompany,
            "order_branch_id": event.deliveryFlow.orderBranchId,
            "order_customer_id": event.deliveryFlow.orderCustomerId,
            "order_customer_name": event.deliveryFlow.orderCustomerName,
            "order_customer_mobile": event.deliveryFlow.orderCustomerMobile,
            "order_payment_method": event.deliveryFlow.orderPaymentMethod,
            "order_amount": event.deliveryFlow.orderAmount,
            "order_discount": event.deliveryFlow.orderDiscount,
            "order_total": event.deliveryFlow.orderTotal,
            "order_status": event.deliveryFlow.orderStatus,
            "order_status_string": event.deliveryFlow.orderStatusString,
            "order_type": event.deliveryFlow.orderType,
            "order_accepted_user_id": event.deliveryFlow.orderAcceptedUserId,
            "order_invoice_id": event.deliveryFlow.orderInvoiceId,
            "order_delivery_person_id": event.deliveryFlow.orderDeliveryPersonId
            // need to change
          }
          )
      );

      if (response.statusCode == 200) {
        yield DeliveryFlowSuccess('Success');
      } else {
        yield DeliveryFlowFailed('Failed');
      }
    }
    catch (e) {
      String errorObject = e.toString().split(':')[1];
      yield DeliveryFlowFailedException(errorObject);
    }
  }

}