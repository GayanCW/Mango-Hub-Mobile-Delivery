import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';


class FirebaseInitialize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ViewUserPage();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class ViewUserPage extends StatefulWidget {
  @override
  _ViewUserPageState createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {

  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    Size _size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: _fireStoreDataBase.collection('OrderDelivery').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          else{
            snapshot.data.documents.map((document) => OrderModel.fromJson(document.data())).toList();
            List<OrderProductList> productList = new List<OrderProductList>();
            List<OrderAditionalCharges> aditionalChargesList = new List<OrderAditionalCharges>();

            nearbyOrders.clear();

            for(int index=0; index<snapshot.data.documents.length; index++) {
              OrderGeo singleGeo= OrderGeo();
              singleGeo.shop =   snapshot.data.documents[index]['order_geo']['shop'];
              singleGeo.delivery =  snapshot.data.documents[index]['order_geo']['delivery'];


              for(int prodIndex=0; prodIndex<snapshot.data.documents[index]['order_product_list'].length; prodIndex++){
                productList.add(OrderProductList(
                  stockId: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_id'],
                  stockBaseProductId: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_base_product_id'],
                  stockVariantId: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_variant_id'],
                  stockVariantTag: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_variant_tag'],
                  stockUnitCost: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_unit_cost'],
                  stockUnitPrice: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_unit_price'],
                  stockUnitDiscountType: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_unit_discount_type'],
                  stockUnitDiscountValue: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_unit_discount_value'],
                  stockUnitDiscountAmount: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_unit_discount_amount'],
                  stockQty: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_qty'],
                  stockCompany: snapshot.data.documents[index]['order_product_list'][prodIndex]['stock_company'],
                ));
              }
              for(int acIndex=0; acIndex<snapshot.data.documents[index]['order_aditional_charges'].length; acIndex++){
                aditionalChargesList.add(OrderAditionalCharges(
                  type: snapshot.data.documents[index]['order_aditional_charges'][acIndex]['type'],
                  amount: snapshot.data.documents[index]['order_aditional_charges'][acIndex]['amount'],
                ));
              }

              nearbyOrders.add(OrderModel(

                orderProductList: productList,
                orderAditionalCharges: aditionalChargesList,
                orderGeo: singleGeo,
                sId: snapshot.data.documents[index]['_id'],
                orderDate: snapshot.data.documents[index]['order_date'],
                orderCompany: snapshot.data.documents[index]['order_company'],
                orderBranchId: snapshot.data.documents[index]['order_branch_id'],
                orderCustomerId: snapshot.data.documents[index]['order_customer_id'],
                orderCustomerName: snapshot.data.documents[index]['order_customer_name'],
                orderCustomerMobile: snapshot.data.documents[index]['order_customer_mobile'],
                orderPaymentMethod: snapshot.data.documents[index]['order_payment_method'],
                orderAmount: snapshot.data.documents[index]['order_amount'],
                orderDiscount: snapshot.data.documents[index]['order_discount'],
                orderTotal: snapshot.data.documents[index]['order_total'],
                orderAdvancePayment: snapshot.data.documents[index]['order_advance_payment'],
                orderStatus: snapshot.data.documents[index]['order_status'],
                orderStatusString: snapshot.data.documents[index]['order_status_string'],
                orderType: snapshot.data.documents[index]['order_type'],
                orderAcceptedUserId: snapshot.data.documents[index]['order_accepted_user_id'],
                orderInvoiceId: snapshot.data.documents[index]['order_invoice_id'],
                orderDeliveryPersonId: snapshot.data.documents[index]['order_delivery_person_id'],
                createdAt: snapshot.data.documents[index]['createdAt'],
                updatedAt: snapshot.data.documents[index]['updatedAt'],
                iV: snapshot.data.documents[index]['__v'],
              ));
            }
          }
          // return Container(
          //   // margin: EdgeInsets.only(top: _size.height*0.65,/* left: 10.0, right: 10.0*/),
          //   // color: Colors.orange,
          //   child: (orderAllDetails.isNotEmpty|| orderAllDetails!=null)?ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: orderAllDetails.length,
          //       itemBuilder: (context, index){
          //         return GestureDetector(
          //           child: Container(
          //             width: _size.width,
          //             margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
          //             decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.grey,
          //                     offset: Offset(2.0, 2.0),
          //                     blurRadius: 5.0,
          //                     spreadRadius: 1.0,
          //                   ),
          //                 ]
          //             ),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 SizedBox(height: 10,),
          //               Text(nearbyCompaniesList[index].branchName, style: TextStyle(fontSize: 30),),
          //               Text(orderAllDetails[index].orderCustomerName ,style: TextStyle(fontSize: 20)),
          //               Text(orderAllDetails[index].orderGeo.delivery, style: TextStyle(fontSize: 20)),
          //               // Text(nearbyCompaniesList[index].branchName, style: TextStyle(fontSize: 20)),
          //                 SizedBox(height: 10,),
          //             ],
          //             )
          //           ),
          //           onTap: (){
          //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OrderPickUI()));
          //           },
          //         );
          //       }): Container(color: Colors.orange,),
          // );
          return Container();
        }
    );
  }

}




