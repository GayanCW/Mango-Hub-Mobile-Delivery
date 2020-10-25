import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mangoHub/src/screens/Dashboard.dart';



class Tabs extends StatefulWidget {
  final String pageTitle;

  Tabs({Key key, this.pageTitle}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Dashboard())));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[],),),);}}
