List<OrderModel> nearbyOrders = new List<OrderModel>();
List<OrderModel> allOrderCompanies = new List<OrderModel>();
List<OrderModel> orderAllDetails = new List<OrderModel>();

class OrderModel {
  OrderGeo orderGeo;
  List<OrderProductList> orderProductList;
  List<OrderAditionalCharges> orderAditionalCharges;
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
        this.orderAditionalCharges,
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
      orderAditionalCharges = new List<OrderAditionalCharges>();
      json['order_aditional_charges'].forEach((v) {
        orderAditionalCharges.add(new OrderAditionalCharges.fromJson(v));
      });
    }
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
    if (this.orderAditionalCharges != null) {
      data['order_aditional_charges'] =
          this.orderAditionalCharges.map((v) => v.toJson()).toList();
    }
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
}

class OrderGeo {
  String shop;
  String delivery;

  OrderGeo({this.shop, this.delivery});

  OrderGeo.fromJson(Map<String, dynamic> json){
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

class OrderAditionalCharges {
  String type;
  int amount;

  OrderAditionalCharges({this.type, this.amount});

  OrderAditionalCharges.fromJson(Map<String, dynamic> json) {
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

/*
class OrderModel {
  List<OrderProductList> orderProductList;
  List<OrderAditionalCharges> orderAditionalCharges;
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
  OrderGeo orderGeo;
  String createdAt;
  String updatedAt;
  int iV;

  OrderModel(
      {this.orderProductList,
        this.orderAditionalCharges,
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
        this.orderGeo,
        this.createdAt,
        this.updatedAt,
        this.iV});

  OrderModel.fromJson(Map<String, dynamic> json) {
    if (json['order_product_list'] != null) {
      orderProductList = new List<OrderProductList>();
      json['order_product_list'].forEach((v) {
        orderProductList.add(new OrderProductList.fromJson(v));
      });
    }
    if (json['order_aditional_charges'] != null) {
      orderAditionalCharges = new List<OrderAditionalCharges>();
      json['order_aditional_charges'].forEach((v) {
        orderAditionalCharges.add(new OrderAditionalCharges.fromJson(v));
      });
    }
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
    orderGeo = json['order_geo'] != null
        ? new OrderGeo.fromJson(json['order_geo'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderProductList != null) {
      data['order_product_list'] =
          this.orderProductList.map((v) => v.toJson()).toList();
    }
    if (this.orderAditionalCharges != null) {
      data['order_aditional_charges'] =
          this.orderAditionalCharges.map((v) => v.toJson()).toList();
    }
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
    if (this.orderGeo != null) {
      data['order_geo'] = this.orderGeo.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class OrderProductList1 {
  String stockBaseProductCode;
  String stockBaseProductId;
  String stockBranch;
  String stockCompany;
  List<Null> stockGrns;
  int stockQty;
  List<Null> stockSuppliers;
  int stockUnitCost;
  int stockUnitDiscountAmount;
  String stockUnitDiscountType;
  int stockUnitDiscountValue;
  int stockUnitPrice;
  String stockVariantId;
  String stockVariantTag;

  OrderProductList1(
      {this.stockBaseProductCode,
        this.stockBaseProductId,
        this.stockBranch,
        this.stockCompany,
        this.stockGrns,
        this.stockQty,
        this.stockSuppliers,
        this.stockUnitCost,
        this.stockUnitDiscountAmount,
        this.stockUnitDiscountType,
        this.stockUnitDiscountValue,
        this.stockUnitPrice,
        this.stockVariantId,
        this.stockVariantTag});

  OrderProductList1.fromJson(Map<String, dynamic> json) {
    stockBaseProductCode = json['stock_base_product_code'];
    stockBaseProductId = json['stock_base_product_id'];
    stockBranch = json['stock_branch'];
    stockCompany = json['stock_company'];
    if (json['stock_grns'] != null) {
      stockGrns = new List<Null>();
      json['stock_grns'].forEach((v) {
        stockGrns.add(new Null.fromJson(v));
      });
    }
    stockQty = json['stock_qty'];
    if (json['stock_suppliers'] != null) {
      stockSuppliers = new List<Null>();
      json['stock_suppliers'].forEach((v) {
        stockSuppliers.add(new Null.fromJson(v));
      });
    }
    stockUnitCost = json['stock_unit_cost'];
    stockUnitDiscountAmount = json['stock_unit_discount_amount'];
    stockUnitDiscountType = json['stock_unit_discount_type'];
    stockUnitDiscountValue = json['stock_unit_discount_value'];
    stockUnitPrice = json['stock_unit_price'];
    stockVariantId = json['stock_variant_id'];
    stockVariantTag = json['stock_variant_tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock_base_product_code'] = this.stockBaseProductCode;
    data['stock_base_product_id'] = this.stockBaseProductId;
    data['stock_branch'] = this.stockBranch;
    data['stock_company'] = this.stockCompany;
    if (this.stockGrns != null) {
      data['stock_grns'] = this.stockGrns.map((v) => v.toJson()).toList();
    }
    data['stock_qty'] = this.stockQty;
    if (this.stockSuppliers != null) {
      data['stock_suppliers'] =
          this.stockSuppliers.map((v) => v.toJson()).toList();
    }
    data['stock_unit_cost'] = this.stockUnitCost;
    data['stock_unit_discount_amount'] = this.stockUnitDiscountAmount;
    data['stock_unit_discount_type'] = this.stockUnitDiscountType;
    data['stock_unit_discount_value'] = this.stockUnitDiscountValue;
    data['stock_unit_price'] = this.stockUnitPrice;
    data['stock_variant_id'] = this.stockVariantId;
    data['stock_variant_tag'] = this.stockVariantTag;
    return data;
  }
}

class OrderAditionalCharges {
  String type;
  int amount;

  OrderAditionalCharges({this.type, this.amount});

  OrderAditionalCharges.fromJson(Map<String, dynamic> json) {
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
*/
