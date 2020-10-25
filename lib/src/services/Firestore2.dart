

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mangoHub/src/models/APImodels/OrderModel.dart';

class Firestore2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return FirebaseRealTime();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class FirebaseRealTime extends StatefulWidget {
  @override
  _FirebaseRealTimeState createState() => _FirebaseRealTimeState();
}

class _FirebaseRealTimeState extends State<FirebaseRealTime> {
  FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  List<OrderModel> allOrderCompanyIds = [];


  void getData() async{
    await databaseReference
        .collection("OrderDelivery")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f){
        print('length: ${f.data()['order_amount']}}');
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
    int x;
    String val;
    return new StreamBuilder(
        stream: _fireStoreDataBase.collection('OrderDelivery').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          else{
            snapshot.data.documents.map((document) => OrderModel.fromJson(document.data())).toList();
            allOrderCompanyIds.clear();
            for(int index=0; index<snapshot.data.documents.length; index++){
              allOrderCompanyIds.add(new OrderModel(
                sId: snapshot.data.documents[index]['order_branch_id']
              ));
            }
            x = snapshot.data.documents.length;
            val = snapshot.data.documents[0]['order_branch_id'].toString();
          }
          return Center(child: Text(allOrderCompanyIds[1].sId));
        }
    );
  }
}

void listenChanges(){
  CollectionReference reference = FirebaseFirestore.instance.collection('OrderDelivery');
  reference.snapshots().listen((querySnapshot) {
    querySnapshot.docChanges.forEach((change) {
      print("change:");
      print(change.doc.id);

      for(int index=0; index<change.doc.id.length; index++){
        print("order_company :");
      }
    });
  });
}



