part of 'accept_delivery_bloc.dart';

@immutable
abstract class AcceptDeliveryEvent {}

class AcceptDelivery extends AcceptDeliveryEvent{
  AcceptDelivery({
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

  final AcceptDeliveryOrderGeo orderGeo;
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

class AcceptDeliveryOrderGeo {
  String shop;
  String delivery;

  AcceptDeliveryOrderGeo({this.shop, this.delivery});
}

