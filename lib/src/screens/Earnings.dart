import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mangoHub/src/shared/Colors.dart';

class Earnings extends StatefulWidget {
  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  var rng = new Random();
  DateTime now = DateTime.now();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  List<double> prices = [
    2550.00,
    3175.50,
    300.00,
    575.00,
    8500.0,
    4999.99,
    2000.00,
    1525.80,
    5000.00,
    2990.90,
    100.00,
    0.00,
    0.00,
    150.00,
    3750.25,
    1496.79,
    3600.00,
    412.56,
    460.00,
    300.00,
    2100.00,
    1000.00,
  ];

  List<String> months = [
    'January','February','March','April','May','June','July','August','September','October','November','December'
  ];

  @override
  Widget build(BuildContext context) {
    double _total = total();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Card(
                  elevation: 4,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text("Total", style: TextStyle(color: Colors.white,fontSize: 60.0, fontWeight: FontWeight.w600),),
                      // SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Rs. ', style: TextStyle(color: Colors.white60,fontSize: 50.0, fontWeight: FontWeight.w700),),
                          Text(oCcy.format(_total), style: TextStyle(color: mangoOrange,fontSize: 50.0, fontWeight: FontWeight.w700),),
                        ],
                      ),
                    ],),),
                ),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    // Text("Last 30 Days - ", style: TextStyle(color: Colors.white,fontSize: 25, fontWeight: FontWeight.w700),),
                    Text('[ '+ months[now.month-1] +' '+ now.year.toString() +' ]', style: TextStyle(color: Colors.white,fontSize: 25, fontWeight: FontWeight.w300),),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 140.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: prices.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (index==0)?"Today":
                                (index==1)?"Yesterday":
                                "${22-index} Day",
                                style: TextStyle(color: Colors.white,fontSize: 22, fontWeight: FontWeight.w300),),
                              Text(prices[index].toStringAsFixed(2),
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),),
                            ],
                          ),
                        );
                      }
                  ),
                  Container(
                    height: 200,
                    color: mangoBlue,
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  double total(){
    double total = 0;
    for(int index = 0; index<prices.length; index++){
      total = total+prices[index];
    }
    return total;
  }
}


