
List<OrderModel> nearbyOrders = new List<OrderModel>();
List<OrderModel> acceptedOrder = new List<OrderModel>();
List<OrderModel> deliveryHistory = new List<OrderModel>();
List<OrderModel> sortedDeliveryHistory = new List<OrderModel>();
List<DeliveryHistoryModel> deliveryHistoryAsDays = new List<DeliveryHistoryModel>();


class DeliveryHistoryModel {
  List<OrderModel> orderModel;
  DeliveryHistoryModel({this.orderModel});

  DeliveryHistoryModel.fromJson(json) {
    List<dynamic> fixedLengthList = json;
    if(json==null) return;
    try{
      orderModel = OrderModel.listFromJson(fixedLengthList);
    }catch(e){
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {'orderModel': orderModel};
  }
  static List<DeliveryHistoryModel> listFromJson(List<dynamic> json) {
    return json == null
        ? new List<DeliveryHistoryModel>()
        : json.map((value) => new DeliveryHistoryModel.fromJson(value)).toList();
  }
  static Map<String, DeliveryHistoryModel> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = new Map<String, DeliveryHistoryModel>();
    if (json != null && json.length > 0) {
      json.forEach((String key, Map<String, dynamic> value) =>
      map[key] = new DeliveryHistoryModel.fromJson(value));
    }
    return map;
  }
}

// class OrderModel {
//   String message;
//   OrderGeo orderGeo;
//   List<OrderProductList> orderProductList;
//   List<OrderAditionalCharges> orderAditionalCharges;
//   String sId;
//   String orderDate;
//   String orderCompany;
//   String orderBranchId;
//   String orderCustomerId;
//   String orderCustomerName;
//   String orderCustomerMobile;
//   String orderNote;
//   String orderPaymentMethod;
//   int orderAmount;
//   int orderDiscount;
//   int orderTotal;
//   int orderAdvancePayment;
//   bool orderStatus;
//   String orderStatusString;
//   String orderType;
//   String orderAcceptedUserId;
//   String orderInvoiceId;
//   String orderDeliveryPersonId;
//   String createdAt;
//   String updatedAt;
//   int iV;
//
//   OrderModel(
//       { this.message,
//         this.orderGeo,
//         this.orderProductList,
//         this.orderAditionalCharges,
//         this.sId,
//         this.orderDate,
//         this.orderCompany,
//         this.orderBranchId,
//         this.orderCustomerId,
//         this.orderCustomerName,
//         this.orderCustomerMobile,
//         this.orderPaymentMethod,
//         this.orderAmount,
//         this.orderDiscount,
//         this.orderTotal,
//         this.orderAdvancePayment,
//         this.orderStatus,
//         this.orderStatusString,
//         this.orderType,
//         this.orderAcceptedUserId,
//         this.orderInvoiceId,
//         this.orderDeliveryPersonId,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   OrderModel.fromJson(Map<String, dynamic> json) {
//     orderGeo = json['order_geo'] != null
//         ? new OrderGeo.fromJson(json['order_geo'])
//         : null;
//     if (json['order_product_list'] != null) {
//       orderProductList = new List<OrderProductList>();
//       json['order_product_list'].forEach((v) {
//         orderProductList.add(new OrderProductList.fromJson(v));
//       });
//     }
//     if (json['order_aditional_charges'] != null) {
//       orderAditionalCharges = new List<OrderAditionalCharges>();
//       json['order_aditional_charges'].forEach((v) {
//         orderAditionalCharges.add(new OrderAditionalCharges.fromJson(v));
//       });
//     }
//     message = json['message'];
//     sId = json['_id'];
//     orderDate = json['order_date'];
//     orderCompany = json['order_company'];
//     orderBranchId = json['order_branch_id'];
//     orderCustomerId = json['order_customer_id'];
//     orderCustomerName = json['order_customer_name'];
//     orderCustomerMobile = json['order_customer_mobile'];
//     orderNote = json['order_note'];
//     orderPaymentMethod = json['order_payment_method'];
//     orderAmount = json['order_amount'];
//     orderDiscount = json['order_discount'];
//     orderTotal = json['order_total'];
//     orderAdvancePayment = json['order_advance_payment'];
//     orderStatus = json['order_status'];
//     orderStatusString = json['order_status_string'];
//     orderType = json['order_type'];
//     orderAcceptedUserId = json['order_accepted_user_id'];
//     orderInvoiceId = json['order_invoice_id'];
//     orderDeliveryPersonId = json['order_delivery_person_id'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.orderGeo != null) {
//       data['order_geo'] = this.orderGeo.toJson();
//     }
//     if (this.orderProductList != null) {
//       data['order_product_list'] =
//           this.orderProductList.map((v) => v.toJson()).toList();
//     }
//     if (this.orderAditionalCharges != null) {
//       data['order_aditional_charges'] =
//           this.orderAditionalCharges.map((v) => v.toJson()).toList();
//     }
//     data['message'] = this.message;
//     data['_id'] = this.sId;
//     data['order_date'] = this.orderDate;
//     data['order_company'] = this.orderCompany;
//     data['order_branch_id'] = this.orderBranchId;
//     data['order_customer_id'] = this.orderCustomerId;
//     data['order_customer_name'] = this.orderCustomerName;
//     data['order_customer_mobile'] = this.orderCustomerMobile;
//     data['order_note'] = this.orderNote;
//     data['order_payment_method'] = this.orderPaymentMethod;
//     data['order_amount'] = this.orderAmount;
//     data['order_discount'] = this.orderDiscount;
//     data['order_total'] = this.orderTotal;
//     data['order_advance_payment'] = this.orderAdvancePayment;
//     data['order_status'] = this.orderStatus;
//     data['order_status_string'] = this.orderStatusString;
//     data['order_type'] = this.orderType;
//     data['order_accepted_user_id'] = this.orderAcceptedUserId;
//     data['order_invoice_id'] = this.orderInvoiceId;
//     data['order_delivery_person_id'] = this.orderDeliveryPersonId;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
//
//   static List<OrderModel> listFromJson(List<dynamic> json) {
//     return json == null
//         ? new List<OrderModel>()
//         : json.map((value) => new OrderModel.fromJson(value)).toList();
//   }
//   static Map<String, OrderModel> mapFromJson(Map<String, Map<String, dynamic>> json) {
//     var map = new Map<String, OrderModel>();
//     if (json != null && json.length > 0) {
//       json.forEach((String key, Map<String, dynamic> value) =>
//       map[key] = new OrderModel.fromJson(value));
//     }
//     return map;
//   }
// }

//
// class OrderProductList {
//   String stockBaseProductCode;
//   String stockBaseProductId;
//   String stockVariantId;
//   String stockVariantTag;
//   int stockUnitCost;
//   int stockUnitPrice;
//   String stockUnitDiscountType;
//   int stockUnitDiscountValue;
//   int stockUnitDiscountAmount;
//   int stockQty;
//   String stockCompany;
//
//   OrderProductList(
//       {this.stockBaseProductCode,
//         this.stockBaseProductId,
//         this.stockVariantId,
//         this.stockVariantTag,
//         this.stockUnitCost,
//         this.stockUnitPrice,
//         this.stockUnitDiscountType,
//         this.stockUnitDiscountValue,
//         this.stockUnitDiscountAmount,
//         this.stockQty,
//         this.stockCompany});
//
//   OrderProductList.fromJson(Map<String, dynamic> json) {
//     stockBaseProductCode = json['stock_base_product_code'];
//     stockBaseProductId = json['stock_base_product_id'];
//     stockVariantId = json['stock_variant_id'];
//     stockVariantTag = json['stock_variant_tag'];
//     stockUnitCost = json['stock_unit_cost'];
//     stockUnitPrice = json['stock_unit_price'];
//     stockUnitDiscountType = json['stock_unit_discount_type'];
//     stockUnitDiscountValue = json['stock_unit_discount_value'];
//     stockUnitDiscountAmount = json['stock_unit_discount_amount'];
//     stockQty = json['stock_qty'];
//     stockCompany = json['stock_company'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['stock_base_product_code'] = this.stockBaseProductCode;
//     data['stock_base_product_id'] = this.stockBaseProductId;
//     data['stock_variant_id'] = this.stockVariantId;
//     data['stock_variant_tag'] = this.stockVariantTag;
//     data['stock_unit_cost'] = this.stockUnitCost;
//     data['stock_unit_price'] = this.stockUnitPrice;
//     data['stock_unit_discount_type'] = this.stockUnitDiscountType;
//     data['stock_unit_discount_value'] = this.stockUnitDiscountValue;
//     data['stock_unit_discount_amount'] = this.stockUnitDiscountAmount;
//     data['stock_qty'] = this.stockQty;
//     data['stock_company'] = this.stockCompany;
//     return data;
//   }
// }
// class OrderGeo {
//   String shop;
//   String delivery;
//
//   OrderGeo({this.shop, this.delivery});
//
//   OrderGeo.fromJson(Map<String, dynamic> json){
//     shop = json['shop'];
//     delivery = json['delivery'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['shop'] = this.shop;
//     data['delivery'] = this.delivery;
//     return data;
//   }
// }

// class OrderAditionalCharges {
//   String type;
//   int amount;
//
//   OrderAditionalCharges({this.type, this.amount});
//
//   OrderAditionalCharges.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     amount = json['amount'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['amount'] = this.amount;
//     return data;
//   }
// }

class OrderModel {
  OrderGeo orderGeo;
  List<OrderProductList> orderProductList;
  List<OrderAdditionalCharges> orderAdditionalCharges;
  String message;
  String sId;
  String orderDate;
  String orderCompany;
  String orderBranchId;
  String orderCustomerId;
  String orderCustomerName;
  String orderCustomerMobile;
  String orderPaymentMethod;
  int orderAmount;
  int orderDiscount;
  int orderTotal;
  int orderAdvancePayment;
  bool orderStatus;
  String orderStatusString;
  String orderType;
  String orderAcceptedUserId;
  String orderInvoiceId;
  String orderDeliveryPersonId;
  String createdAt;
  String updatedAt;
  int iV;

  OrderModel(
      {this.orderGeo,
        this.orderProductList,
        this.orderAdditionalCharges,
        this.message,
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
        this.orderAdvancePayment,
        this.orderStatus,
        this.orderStatusString,
        this.orderType,
        this.orderAcceptedUserId,
        this.orderInvoiceId,
        this.orderDeliveryPersonId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderGeo = json['order_geo'] != null
        ? new OrderGeo.fromJson(json['order_geo'])
        : null;
    if (json['order_product_list'] != null) {
      orderProductList = new List<OrderProductList>();
      json['order_product_list'].forEach((v) {
        orderProductList.add(new OrderProductList.fromJson(v));
      });
    }
    if (json['order_aditional_charges'] != null) {
      orderAdditionalCharges = new List<OrderAdditionalCharges>();
      json['order_aditional_charges'].forEach((v) {
        orderAdditionalCharges.add(new OrderAdditionalCharges.fromJson(v));
      });
    }
    message = json['message'];
    sId = json['_id'];
    orderDate = json['order_date'];
    orderCompany = json['order_company'];
    orderBranchId = json['order_branch_id'];
    orderCustomerId = json['order_customer_id'];
    orderCustomerName = json['order_customer_name'];
    orderCustomerMobile = json['order_customer_mobile'];
    orderPaymentMethod = json['order_payment_method'];
    orderAmount = json['order_amount'];
    orderDiscount = json['order_discount'];
    orderTotal = json['order_total'];
    orderAdvancePayment = json['order_advance_payment'];
    orderStatus = json['order_status'];
    orderStatusString = json['order_status_string'];
    orderType = json['order_type'];
    orderAcceptedUserId = json['order_accepted_user_id'];
    orderInvoiceId = json['order_invoice_id'];
    orderDeliveryPersonId = json['order_delivery_person_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderGeo != null) {
      data['order_geo'] = this.orderGeo.toJson();
    }
    if (this.orderProductList != null) {
      data['order_product_list'] =
          this.orderProductList.map((v) => v.toJson()).toList();
    }
    if (this.orderAdditionalCharges != null) {
      data['order_aditional_charges'] =
          this.orderAdditionalCharges.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['_id'] = this.sId;
    data['order_date'] = this.orderDate;
    data['order_company'] = this.orderCompany;
    data['order_branch_id'] = this.orderBranchId;
    data['order_customer_id'] = this.orderCustomerId;
    data['order_customer_name'] = this.orderCustomerName;
    data['order_customer_mobile'] = this.orderCustomerMobile;
    data['order_payment_method'] = this.orderPaymentMethod;
    data['order_amount'] = this.orderAmount;
    data['order_discount'] = this.orderDiscount;
    data['order_total'] = this.orderTotal;
    data['order_advance_payment'] = this.orderAdvancePayment;
    data['order_status'] = this.orderStatus;
    data['order_status_string'] = this.orderStatusString;
    data['order_type'] = this.orderType;
    data['order_accepted_user_id'] = this.orderAcceptedUserId;
    data['order_invoice_id'] = this.orderInvoiceId;
    data['order_delivery_person_id'] = this.orderDeliveryPersonId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
  static List<OrderModel> listFromJson(List<dynamic> json) {
    return json == null
        ? new List<OrderModel>()
        : json.map((value) => new OrderModel.fromJson(value)).toList();
  }
  static Map<String, OrderModel> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = new Map<String, OrderModel>();
    if (json != null && json.length > 0) {
      json.forEach((String key, Map<String, dynamic> value) =>
      map[key] = new OrderModel.fromJson(value));
    }
    return map;
  }
}

class OrderGeo {
  String shop;
  String delivery;

  OrderGeo({this.shop, this.delivery});

  OrderGeo.fromJson(Map<String, dynamic> json) {
    shop = json['shop'];
    delivery = json['delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop'] = this.shop;
    data['delivery'] = this.delivery;
    return data;
  }
}

class OrderProductList {
  String stockId;
  String stockBaseProductId;
  String stockBaseProductCode;
  String stockVariantId;
  String stockVariantTag;
  int stockUnitCost;
  int stockUnitPrice;
  String stockUnitDiscountType;
  int stockUnitDiscountValue;
  int stockUnitDiscountAmount;
  int stockQty;
  String stockCompany;

  OrderProductList(
      {this.stockId,
        this.stockBaseProductId,
        this.stockBaseProductCode,
        this.stockVariantId,
        this.stockVariantTag,
        this.stockUnitCost,
        this.stockUnitPrice,
        this.stockUnitDiscountType,
        this.stockUnitDiscountValue,
        this.stockUnitDiscountAmount,
        this.stockQty,
        this.stockCompany});

  OrderProductList.fromJson(Map<String, dynamic> json) {
    stockId = json['stock_id'];
    stockBaseProductId = json['stock_base_product_id'];
    stockBaseProductCode = json['stock_base_product_code'];
    stockVariantId = json['stock_variant_id'];
    stockVariantTag = json['stock_variant_tag'];
    stockUnitCost = json['stock_unit_cost'];
    stockUnitPrice = json['stock_unit_price'];
    stockUnitDiscountType = json['stock_unit_discount_type'];
    stockUnitDiscountValue = json['stock_unit_discount_value'];
    stockUnitDiscountAmount = json['stock_unit_discount_amount'];
    stockQty = json['stock_qty'];
    stockCompany = json['stock_company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock_id'] = this.stockId;
    data['stock_base_product_id'] = this.stockBaseProductId;
    data['stock_base_product_code'] = this.stockBaseProductCode;
    data['stock_variant_id'] = this.stockVariantId;
    data['stock_variant_tag'] = this.stockVariantTag;
    data['stock_unit_cost'] = this.stockUnitCost;
    data['stock_unit_price'] = this.stockUnitPrice;
    data['stock_unit_discount_type'] = this.stockUnitDiscountType;
    data['stock_unit_discount_value'] = this.stockUnitDiscountValue;
    data['stock_unit_discount_amount'] = this.stockUnitDiscountAmount;
    data['stock_qty'] = this.stockQty;
    data['stock_company'] = this.stockCompany;
    return data;
  }
}

class OrderAdditionalCharges {
  String type;
  int amount;

  OrderAdditionalCharges({this.type, this.amount});

  OrderAdditionalCharges.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['amount'] = this.amount;
    return data;
  }
}
