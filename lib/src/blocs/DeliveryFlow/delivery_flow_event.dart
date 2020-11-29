part of 'delivery_flow_bloc.dart';

@immutable
abstract class DeliveryFlowEvent {}

// ignore: must_be_immutable
class AcceptDelivery extends DeliveryFlowEvent{
  DeliveryFlow deliveryFlow;
  AcceptDelivery(this.deliveryFlow);
}
// ignore: must_be_immutable
class HandoverOrder  extends DeliveryFlowEvent{
  DeliveryFlow deliveryFlow;
  HandoverOrder(this.deliveryFlow);
}
// ignore: must_be_immutable
class DeliveredOrder extends DeliveryFlowEvent{
  DeliveryFlow deliveryFlow;
  DeliveredOrder(this.deliveryFlow);
}

class DeliveryFlow {
  DeliveryFlow({
    this.orderGeo,
    this.orderProductList,
    this.orderAdditionalCharges,
    this.sId,
    this.orderDate,
    this.orderCompany,
    this.orderBranchId,
    this.orderCustomerId,
    this.orderCustomerName,
    this.orderCustomerMobile,
    this.orderPaymentMethod,
    this.orderAmount,
    this.orderDiscount,
    this.orderTotal,
    this.orderStatus,
    this.orderStatusString,
    this.orderType,
    this.orderAcceptedUserId,
    this.orderInvoiceId,
    this.orderDeliveryPersonId
  });

  final GeoCoordinates orderGeo;
  final List<dynamic> orderProductList;
  final List<dynamic> orderAdditionalCharges;
  final String sId;
  final String orderDate;
  final String orderCompany;
  final String orderBranchId;
  final String orderCustomerId;
  final String orderCustomerName;
  final String orderCustomerMobile;
  final String orderPaymentMethod;
  final int orderAmount;
  final int orderDiscount;
  final int orderTotal;
  final bool orderStatus;
  final String orderStatusString;
  final String orderType;
  final String orderAcceptedUserId;
  final String orderInvoiceId;
  final String orderDeliveryPersonId;
}

class GeoCoordinates {
  String shop;
  String delivery;

  GeoCoordinates({this.shop, this.delivery});
}