
import 'package:flutter/material.dart';
import 'package:mangoHub/src/screens/Home.dart';
import 'package:mangoHub/src/services/CloudFirestore.dart';
import 'package:mangoHub/src/shared/Colors.dart';

import 'drawer.dart';

class Dashboard extends StatefulWidget {
  final String pageTitle;
  Dashboard({Key key, this.pageTitle}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      // ProfileScreen(),
      Text('Profile'),
      // Details(),
      // FirebaseInitialize(),
      Home(),
      // MyHomePage(title: 'Flutter Circle Progress')
      // OrderPage(),
      // Details()
      Text('Details'),
      // Test()
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // bottomNavigationBar: BottomNavigationBarr(),

        drawer: DrawerClass(),
        body: _tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:Icon(Icons.supervisor_account),
              title:Text('Profile'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title:Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.refresh),
              title:Text('Details'),
            ),

          ],

          currentIndex:  _selectedIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: mangoOrange,
          onTap: _onItemTapped,


        ),
      ),
    );

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}