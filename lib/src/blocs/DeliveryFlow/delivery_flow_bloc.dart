import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/shared/GlobalData.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:mangoHub/src/shared/Repository.dart';

part 'delivery_flow_event.dart';
part 'delivery_flow_state.dart';

class DeliveryFlowBloc extends Bloc<DeliveryFlowEvent, DeliveryFlowState> {
  DeliveryFlowBloc() : super(DeliveryFlowInitial());
  Repository _repository = new Repository();
  OrderModel deliveryFlow = new OrderModel();

  @override
  Stream<DeliveryFlowState> mapEventToState(DeliveryFlowEvent event) async* {
    if (event is AcceptDelivery) {
      yield* _acceptDelivery(event);
    }

    if (event is DeliveredOrder) {
      yield* _deliveredOrder(event);
    }
  }

  Stream<DeliveryFlowState> _acceptDelivery(AcceptDelivery event) async* {
    String token = await _repository.readData('token');
    try {
      final response = await http.put(mainPath+"/inventory/acceptOrderDelivery",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
          body: jsonEncode(<String, dynamic>{
            "order_geo": {
              "shop": event.deliveryFlow.orderGeo.shop,
              "delivery": event.deliveryFlow.orderGeo.delivery
            },
            "order_product_list": event.deliveryFlow.orderProductList,
            "order_aditional_charges": event.deliveryFlow.orderAditionalCharges,
            "_id": event.deliveryFlow.sId,
            "order_date": event.deliveryFlow.orderDate,
            "order_company": event.deliveryFlow.orderCompany,
            "order_branch_id": event.deliveryFlow.orderBranchId,
            "order_customer_id": event.deliveryFlow.orderCustomerId,
            "order_customer_name": event.deliveryFlow.orderCustomerName,
            "order_customer_mobile": event.deliveryFlow.orderCustomerMobile,
            "order_note": "",
            "order_payment_method": event.deliveryFlow.orderPaymentMethod,
            "order_amount": event.deliveryFlow.orderAmount,
            "order_discount": event.deliveryFlow.orderDiscount,
            "order_total": event.deliveryFlow.orderTotal,
            "order_status": event.deliveryFlow.orderStatus,
            "order_status_string": event.deliveryFlow.orderStatusString,
            "order_type": event.deliveryFlow.orderType,
            "order_accepted_user_id": event.deliveryFlow.orderAcceptedUserId,
            "order_invoice_id": event.deliveryFlow.orderInvoiceId,
            "order_delivery_person_id": event.deliveryFlow.orderDeliveryPersonId,
          }
          )
      );

      if (response.statusCode == 200) {
        yield AcceptedDeliverySuccess('Success');
      } else {
        yield AcceptedDeliveryFailed('Failed');
      }
    }
    catch (e) {
      String errorObject = e.toString().split(':')[1];
      yield AcceptedDeliveryFailedException(errorObject);
    }
  }


  Stream<DeliveryFlowState> _deliveredOrder(DeliveredOrder event) async* {
    String token = await _repository.readData('token');
    try {
      final response = await http.put(mainPath+"/inventory/deliveredOrder",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
          body: jsonEncode(<String, dynamic>{
            "order_geo": {
              "shop": event.deliveryFlow.orderGeo.shop,
              "delivery": event.deliveryFlow.orderGeo.delivery
            },
            "order_product_list": event.deliveryFlow.orderProductList,
            "order_aditional_charges": event.deliveryFlow.orderAditionalCharges,
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
        yield DeliveredDeliverySuccess('Success');
      } else {
        yield DeliveredDeliveryFailed('Failed');
      }
    }
    catch (e) {
      String errorObject = e.toString().split(':')[1];
      yield DeliveredDeliveryFailedException(errorObject);
    }
  }

}