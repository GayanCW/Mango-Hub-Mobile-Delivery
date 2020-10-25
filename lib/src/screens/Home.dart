import 'package:flutter/material.dart';
import 'package:mangoHub/src/screens/Orders.dart';
import 'package:mangoHub/src/services/CloudFirestore.dart';
import 'package:mangoHub/src/services/Firestore2.dart';
import 'package:mangoHub/src/shared/Colors.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
          centerTitle: true,
          backgroundColor: mangoOrange,
        ),
        body: FirebaseInitialize2(),
        // body: Orders(),
      ),
    );
  }
}

class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Firestore"),
          centerTitle: true,
          backgroundColor: mangoOrange,
        ),
        body: FirebaseInitialize(),
      ),
    );
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
          centerTitle: true,
          backgroundColor: mangoOrange,
        ),
        body: Firestore2(),
      ),
    );
  }
}

