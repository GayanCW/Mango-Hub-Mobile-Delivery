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
                                Text(DateTime.parse(deliveryHistoryAsDays[index].orderModel[0].updatedAt).toLocal().toString().split(' ')[0], style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: mangoOrange)),
                              ],
                            ),
                            SizedBox(height: 6.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Number of Delivered  ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey[900])),

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateTime.parse(deliveryHistoryAsDays[selectedIndex].orderModel[0].updatedAt).toLocal().toString().split(' ')[0], style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white)),
                    IconButton(
                      onPressed: (){
                        print("press");
                        setState(() {
                          pageIndex--;
                        });
                      },
                      icon: Icon(Icons.arrow_back,
                          size: 30,
                          color: mangoOrange
                      ),
                    ),
                  ],
                ),
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
                                      Text("Time "+DateTime.parse(deliveryHistoryAsDays[selectedIndex].orderModel[index].updatedAt).toLocal().toString().split(' ')[1].split('.')[0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[900])),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  print("press");
                                  // setState(() {
                                  //   pageIndex--;
                                  // });
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

              if(state is GetOrdersHistorySuccess) {
                deliveryHistory.clear();
                deliveryHistoryAsDays.clear();
                bool isStoring = false;
                bool isSwitching = false;
                bool isLooping = false;
                List<OrderModel> _deliveryHistory = new List<OrderModel>();

                int year, month, day, hour, minutes;
                double seconds;
                int selectYear, selectMonth, selectDay, selectHour,
                    selectMinutes;
                double selectSeconds;
                int previousYear, previousMonth, previousDay, previousHour,
                    previousMinutes;
                double previousSeconds;

                for (int index = 0; index <
                    state.deliveryHistoryModel.orderModel.length; index++) {
                  String _dateTime = DateTime.parse(
                      state.deliveryHistoryModel.orderModel[index].updatedAt)
                      .toLocal()
                      .toString();
                  year = int.parse(_dateTime.split('-')[0]);
                  month = int.parse(_dateTime.split('-')[1]);

                  if (year == now.year && month == now.month) {
                    deliveryHistory.insert(
                        index, state.deliveryHistoryModel.orderModel[index]);
                    _deliveryHistory.insert(
                        index, state.deliveryHistoryModel.orderModel[index]);
                    isLooping = true;
                  }
                }
                if (deliveryHistory.isNotEmpty) {
                  if (deliveryHistory.length > 1) {
                    while (isLooping) {
                      int loopingCount = 0;
                      for (int index = 1; index <
                          deliveryHistory.length; index++) {
                        String previousDateTime = DateTime.parse(
                            deliveryHistory[index - 1].updatedAt)
                            .toLocal()
                            .toString();
                        String selectDateTime = DateTime.parse(
                            deliveryHistory[index].updatedAt)
                            .toLocal()
                            .toString();

                        selectYear = int.parse(selectDateTime.split('-')[0]);
                        selectMonth = int.parse(selectDateTime.split('-')[1]);
                        selectDay =
                            int.parse(
                                selectDateTime.split('-')[2].split(' ')[0]);
                        selectHour =
                            int.parse(
                                selectDateTime.substring(11).split(':')[0]);
                        selectMinutes =
                            int.parse(
                                selectDateTime.substring(11).split(':')[1]);
                        selectSeconds = double.parse(
                            selectDateTime.substring(11).split(':')[2]);

                        previousYear =
                            int.parse(previousDateTime.split('-')[0]);
                        previousMonth =
                            int.parse(previousDateTime.split('-')[1]);
                        previousDay =
                            int.parse(
                                previousDateTime.split('-')[2].split(' ')[0]);
                        previousHour =
                            int.parse(
                                previousDateTime.substring(11).split(':')[0]);
                        previousMinutes =
                            int.parse(
                                previousDateTime.substring(11).split(':')[1]);
                        previousSeconds = double.parse(
                            previousDateTime.substring(11).split(':')[2]);


                        // if (previousYear > selectYear && previousYear == now.year && selectYear == now.year) {
                        //   // store previousOrder
                        //   isStoring = true;
                        // }
                        // if (previousYear < selectYear && previousYear == now.year && selectYear == now.year) {
                        //   // switch & store selectOrder
                        //   isSwitching = true;
                        // }
                        // if (previousYear == selectYear && previousYear == now.year && selectYear == now.year) {
                        //   if (previousMonth > selectMonth && previousMonth == now.month && selectMonth == now.month) {
                        //     // store previousOrder
                        //     isStoring = true;
                        //   }
                        //   if (previousMonth < selectMonth && previousMonth == now.month && selectMonth == now.month) {
                        //     // switch & store selectOrder
                        //     isSwitching = true;
                        //   }
                        //   if (previousMonth == selectMonth && previousMonth == now.month && selectMonth == now.month) {
                        //     if (previousDay > selectDay) {
                        //       // store previousOrder
                        //       isStoring = true;
                        //     }
                        //     if (previousDay < selectDay) {
                        //       // switch & store selectOrder
                        //       isSwitching = true;
                        //     }
                        //     if (previousDay == selectDay) {
                        //       if (previousHour > selectHour) {
                        //         // store previousOrder
                        //         isStoring = true;
                        //       }
                        //       if (previousHour < selectHour) {
                        //         // switch & store selectOrder
                        //         isSwitching = true;
                        //       }
                        //       if (previousHour == selectHour) {
                        //         if (previousMinutes > selectMinutes) {
                        //           // store previousOrder
                        //           isStoring = true;
                        //         }
                        //         if (previousMinutes < selectMinutes) {
                        //           // switch & store selectOrder
                        //           isSwitching = true;
                        //         }
                        //         if (previousMinutes == selectMinutes) {
                        //           if (previousSeconds > selectSeconds) {
                        //             // store previousOrder
                        //             isStoring = true;
                        //           }
                        //           if (previousSeconds < selectSeconds) {
                        //             // switch & store selectOrder
                        //             isSwitching = true;
                        //           }
                        //           if (previousSeconds == selectSeconds) {
                        //             // anything
                        //             isStoring = true;
                        //           }
                        //         }
                        //       }
                        //     }
                        //   }
                        // }

                          if (previousDay > selectDay) {
                            // store previousOrder
                            isStoring = true;
                          }
                          if (previousDay < selectDay) {
                            // switch & store selectOrder
                            isSwitching = true;
                          }
                          if (previousDay == selectDay) {
                            if (previousHour > selectHour) {
                              // store previousOrder
                              isStoring = true;
                            }
                            if (previousHour < selectHour) {
                              // switch & store selectOrder
                              isSwitching = true;
                            }
                            if (previousHour == selectHour) {
                              if (previousMinutes > selectMinutes) {
                                // store previousOrder
                                isStoring = true;
                              }
                              if (previousMinutes < selectMinutes) {
                                // switch & store selectOrder
                                isSwitching = true;
                              }
                              if (previousMinutes == selectMinutes) {
                                if (previousSeconds > selectSeconds) {
                                  // store previousOrder
                                  isStoring = true;
                                }
                                if (previousSeconds < selectSeconds) {
                                  // switch & store selectOrder
                                  isSwitching = true;
                                }
                                if (previousSeconds == selectSeconds) {
                                  // anything
                                  isStoring = true;
                                }
                              }
                            }
                          }

                        if (isStoring == true) {
                          deliveryHistory.removeAt(index - 1);
                          deliveryHistory.insert(
                              index - 1, _deliveryHistory[index - 1]);
                          isStoring = false;
                          loopingCount++;
                        }
                        if (isSwitching == true) {
                          deliveryHistory.removeAt(index - 1);
                          deliveryHistory.insert(
                              index - 1, _deliveryHistory[index]);
                          deliveryHistory.removeAt(index);
                          deliveryHistory.insert(
                              index, _deliveryHistory[index - 1]);
                          isSwitching = false;
                          loopingCount = 0;
                        }
                        _deliveryHistory.clear();
                        _deliveryHistory.addAll(deliveryHistory);
                      }

                      if (loopingCount == deliveryHistory.length - 1) {
                        _deliveryHistory.clear();
                        isLooping = false;
                      } else {
                        isLooping = true;
                      }
                      print(deliveryHistory.length.toString());
                    }

                  }
                  if (deliveryHistory.length > 1) {
                    for (int index = 1; index < deliveryHistory.length; index++) {
                      int _day = int.parse(DateTime.parse(deliveryHistory[index-1].updatedAt).toLocal().toString().split('-')[2].split(' ')[0]);
                      day = int.parse(DateTime.parse(deliveryHistory[index].updatedAt).toLocal().toString().split('-')[2].split(' ')[0]);

                      if(_day == day){
                        _deliveryHistory.add(deliveryHistory[index-1]);
                      } else{
                        if(index == 1){
                          _deliveryHistory.add(deliveryHistory[index-1]);
                          deliveryHistoryAsDays.add(
                              DeliveryHistoryModel(
                                  orderModel: _deliveryHistory.toList())
                          );
                        } else{
                          deliveryHistoryAsDays.add(
                              DeliveryHistoryModel(
                                  orderModel: _deliveryHistory.toList())
                          );
                        }
                        _deliveryHistory.clear();
                        _deliveryHistory.add(deliveryHistory[index]);
                      }

                      if(index == deliveryHistory.length-1){
                        deliveryHistoryAsDays.add(
                            DeliveryHistoryModel(
                                orderModel: _deliveryHistory.toList())
                        );
                      }
                    }
                  }
                  if (deliveryHistory.length == 1) {
                    deliveryHistoryAsDays.add(
                        DeliveryHistoryModel(
                            orderModel: deliveryHistory.toList())
                    );
                  }
                }

                _deliveryHistory.clear();
                print(deliveryHistory.length.toString());
                print(deliveryHistoryAsDays.length.toString());
                print('Done');

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////Earnings//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



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
