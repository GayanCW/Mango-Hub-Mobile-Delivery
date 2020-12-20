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
      final response = await http.put(mainPath+"/inventory/acceptOrder",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
            // 'Authorization': "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZmQ0N2JhMmZjMWJiZjAwMGFiNTczOTYiLCJpYXQiOjE2MDg0NDk5ODAxNzIsImV4cCI6MTYwODQ1MDA2NjU3Mn0.MyKeOVdgaWfyAn1AD1b2N83-0RtJQBYX-p5g8vjO_u32WwozPytvqqvL0SMBYeKIxxA_DTS9zYF0T5w8jG2ibn1vA11CgpYAZsnGXDaQWVIhNONJFTBJIbuJzrYcG6iS-nLZIcXbbYlvTXKaBLeQn0g7TDcdp6sbFrd0Lu8BVAM71HvG_0E5ttJ-Fq6Vx8g8LNltvE6gu4t3xz7_UfH39iwZhFEBzr8Ys8xdXcB-QsRBAcq-H0F-OSYfRVP17c_IbH38DdvJxzBGwE1h-fol6Cn1X5mEs34NfJP2oqGisctH14j_UaEaQjwvWoTi4_gea3ZqD6m36_haOSHkwvWckATUt5n5PiLJlKBBmoja_EAtt9vIF06_pXTSiL3yTJgxvbpspNrfGMv2TQknss8D4zcfMaqdx3ToppWfgjjKOcBG0hngdSp6BDKHU7rUcgW121y5sCzjpcAMfmlAshRIF3pHcdJXVievc4YuHqu13uIq4LwlZ9gyKTKvnNIvCIhoeu0qRmhNe6lHUJLPUjM0KyPMopwQXx8gkXaeFZkyqek-0yrlf5SfRrmGCIF1LVmHQuiBOaBHRWzJckgWt8Lu39uApncWGbUIGWeOsaPagA2S1yXBtmJ9HuLSKSsRxgIjIxjo8bkQ73u-dFG5E1O7lZ0bVHmk3oOq_VgojUUuhKM",
          },
          body: jsonEncode(<String, dynamic>{
            "order_geo": {
              "shop": event.deliveryFlow.orderGeo.shop,
              "delivery": event.deliveryFlow.orderGeo.delivery
            },
            "order_product_list": event.deliveryFlow.orderProductList,
            "order_aditional_charges": event.deliveryFlow.orderAditionalCharges,
            "_id": event.deliveryFlow.sId,
            // "_id": "5fd0917ec8d959000aedd525",
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
            // "order_delivery_person_id": event.deliveryFlow.orderDeliveryPersonId
            // "order_delivery_person_id": "5fd47ba2fc1bbf000ab57395"
            "order_delivery_person_id": ""
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
            // 'comp_id': event.deliveryFlow.orderCompany
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