import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mangoHub/src/blocs/Orders/orders_history_bloc.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:mangoHub/src/shared/Repository.dart';

class DeliveryHistory extends StatefulWidget {
  @override
  _DeliveryHistoryState createState() => _DeliveryHistoryState();
}

class _DeliveryHistoryState extends State<DeliveryHistory> {

  Repository _repository = new Repository();
  DateTime now = DateTime.now();
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  final PageController _pageController = PageController(
      initialPage: 0
  );

  int pageIndex=0;
  int selectedIndex=0;

  void _getOrdersHistory()async{
    String _userProfileId = await _repository.readData('userProfileId');
    String _token = await _repository.readData('token');

    BlocProvider.of<OrdersHistoryBloc>(context).add(
        GetOrdersHistory(userProfileId: _userProfileId, token: _token)
    );
  }

  void _onPageChanged(int value) {
    setState(() {
      pageIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _getOrdersHistory();
    print(now.day);
  }

  Widget buildUI(BuildContext context) {

    List<Widget> slider = [
      (deliveryHistoryAsDays.isNotEmpty)?Container(
        child: ListView.builder(
          itemCount: deliveryHistoryAsDays.length,
          itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 100,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text("Date  ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.grey[900])),
                                Text(deliveryHistoryAsDays[index].orderModel[0].orderDate.split('T')[0], style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: mangoOrange)),
                              ],
                            ),
                            SizedBox(height: 6.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Number of Orders  ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey[900])),
                                /*Card(
                                  elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.green[900]),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),

                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(deliveryHistoryAsDays[index].orderModel.length.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey[900])),
                                  )),*/
                                Text(deliveryHistoryAsDays[index].orderModel.length.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.grey[900])),

                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          print("press");
                          setState(() {
                            selectedIndex=index;
                            pageIndex++;
                          });
                        },
                        icon: Icon(Icons.arrow_forward_ios_outlined,
                            size: 20,
                            color: mangoOrange
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    ):Container(),

      (deliveryHistoryAsDays.isNotEmpty)?Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(deliveryHistoryAsDays[selectedIndex].orderModel[0].orderDate.split('T')[0], style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: deliveryHistoryAsDays[selectedIndex].orderModel.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 80,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(deliveryHistoryAsDays[selectedIndex].orderModel[index].orderCustomerName, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.grey[900])),
                                      Text('Rs. '+oCcy.format(deliveryHistoryAsDays[selectedIndex].orderModel[index].orderTotal), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.green)),
                                      Text("Time "+deliveryHistoryAsDays[selectedIndex].orderModel[index].orderDate.split('T')[1].split('.')[0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[900])),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  print("press");
                                  setState(() {
                                    pageIndex--;
                                  });
                                },
                                icon: Icon(Icons.keyboard_arrow_down_outlined,
                                    size: 30,
                                    color: mangoOrange
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ):Container(),
    ];

    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged:_onPageChanged,
      children: [
        slider[pageIndex]
      ],
    );

  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrdersHistoryBloc,OrdersHistoryState>(
            listener: (context, state){
              if(state is GetOrdersHistorySuccess){
                int _nowDay = now.day;
                deliveryHistory.clear();
                deliveryHistoryAsDays.clear();

                for(int index=state.deliveryHistoryModel.orderModel.length; index>0; index--){
                  OrderModel _deliveryHistory = state.deliveryHistoryModel.orderModel[index-1];

                  if(now.year == int.parse(_deliveryHistory.orderDate.split('T')[0].split('-')[0].toString())){
                    if(now.month == int.parse(_deliveryHistory.orderDate.split('T')[0].split('-')[1].split('-')[0].toString())){

                      if (deliveryHistory.isNotEmpty && _nowDay > int.parse(_deliveryHistory.orderDate.split('-')[2].split('T')[0].toString())) {
                        deliveryHistoryAsDays.add(
                            DeliveryHistoryModel(orderModel: deliveryHistory.toList())
                        );
                        deliveryHistory.clear();
                      }

                      while(_nowDay>=int.parse(_deliveryHistory.orderDate.split('-')[2].split('T')[0].toString())) {

                        if (_nowDay == int.parse(_deliveryHistory.orderDate.split('-')[2].split('T')[0].toString())) {
                          OrderGeo orderGeo = OrderGeo(
                              shop: _deliveryHistory.orderGeo.shop,
                              delivery: _deliveryHistory.orderGeo.delivery
                          );
                          deliveryHistory.add(
                              OrderModel(
                                orderProductList: _deliveryHistory
                                    .orderProductList,
                                orderAditionalCharges: _deliveryHistory
                                    .orderAditionalCharges,
                                orderGeo: orderGeo,
                                sId: _deliveryHistory.sId,
                                orderDate: _deliveryHistory.orderDate,
                                orderCompany: _deliveryHistory.orderCompany,
                                orderBranchId: _deliveryHistory.orderBranchId,
                                orderCustomerId: _deliveryHistory
                                    .orderCustomerId,
                                orderCustomerName: _deliveryHistory
                                    .orderCustomerName,
                                orderCustomerMobile: _deliveryHistory
                                    .orderCustomerMobile,
                                orderPaymentMethod: _deliveryHistory
                                    .orderPaymentMethod,
                                orderAmount: _deliveryHistory.orderAmount,
                                orderDiscount: _deliveryHistory.orderDiscount,
                                orderTotal: _deliveryHistory.orderTotal,
                                orderAdvancePayment: _deliveryHistory
                                    .orderAdvancePayment,
                                orderStatus: _deliveryHistory.orderStatus,
                                orderStatusString: _deliveryHistory
                                    .orderStatusString.toString().toLowerCase(),
                                orderType: _deliveryHistory.orderType,
                                orderAcceptedUserId: _deliveryHistory
                                    .orderAcceptedUserId,
                                orderInvoiceId: _deliveryHistory.orderInvoiceId,
                                orderDeliveryPersonId: _deliveryHistory
                                    .orderDeliveryPersonId,
                                createdAt: _deliveryHistory.createdAt,
                                updatedAt: _deliveryHistory.updatedAt,
                                iV: _deliveryHistory.iV,
                              )
                          );
                          break;
                        }
                        else{
                          _nowDay--;
                        }
                      }
                    }
                  }
                }
                  if (deliveryHistory.isNotEmpty) {
                    deliveryHistoryAsDays.add(
                        DeliveryHistoryModel(orderModel: deliveryHistory.toList())
                    );
                    deliveryHistory.clear();
                  }

                  // print(deliveryHistoryAsDays.length);
                  // print(deliveryHistoryAsDays[0].orderModel[0].orderDate);

              }
              if(state is GetOrdersHistoryFailed){

              }
              if(state is GetOrdersHistoryFailedException){

              }
            }
        ),
      ],
      child: BlocBuilder<OrdersHistoryBloc,OrdersHistoryState>(
          builder: (context,state){
            return buildUI(context);
          }
      ),
    );
  }


}
