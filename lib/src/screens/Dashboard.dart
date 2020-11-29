import 'package:flutter/material.dart';
import 'package:mangoHub/src/screens/DeliveryHistory.dart';
import 'package:mangoHub/src/screens/Earnings.dart';
import 'package:mangoHub/src/screens/EditUser.dart';
import 'package:mangoHub/src/screens/Home.dart';
import 'package:mangoHub/src/screens/ProfileScreen.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:mangoHub/src/shared/Repository.dart';
import 'Login.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 1;
  Repository _repository = new Repository();

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      Earnings(),
      Home(),
      DeliveryHistory()
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: mangoGrey,
        appBar: AppBar(
          elevation: (_selectedIndex==0)?1:1,
          title: Text(_appBarTitle[_selectedIndex].toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: mangoOrange)),
          centerTitle: true,
          backgroundColor: mangoGrey,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            IconButton(icon: Icon(Icons.online_prediction), onPressed: (){}),
          ],
        ),
        drawer: drawer(),
        body: _tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:Icon(Icons.monetization_on),
              title:Text('Earnings'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title:Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title:Text('History'),
            ),
          ],

          currentIndex:  _selectedIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: mangoOrange,
          backgroundColor: Colors.grey[900],
          unselectedItemColor: Colors.white60,
          onTap: _onItemTapped,
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/dashboard': (BuildContext context) => Dashboard(),
      },
    );

  }

  Widget drawer() {
    return Drawer(
      child: Stack(
        children: [
          Container(
            color: Colors.grey[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(top: 30.0),
                    color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage("assets/images/delivery-man2.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 100.0,
                          height: 50.0,
                          margin: EdgeInsets.only(left:10.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Mango Driver",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => ProfileScreen()));
                  },
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person, color: mangoOrange, size: 25,),
                        title: Text("About me", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.contact_phone, color: mangoOrange, size: 25,),
                        title: Text("Contacts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
                        onTap: (){},
                      ),
                      ListTile(
                        leading: Icon(Icons.settings, color: mangoOrange, size: 25,),
                        title: Text("Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
                        onTap: (){
                          // Navigator.pushNamed(context, '/editUser');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditUser()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.help, color: mangoOrange, size: 25,),
                        title: Text("Help", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
                        onTap: (){},
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.87),
            child: ListTile(
              leading: Icon(Icons.logout, color: mangoOrange, size: 25,),
              title: Text("logout", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
              onTap: (){
                _repository.deleteData('loginStatus');
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

              },
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> _appBarTitle = [
    'Earnings',
    'Orders',
    'Delivery History'
  ];

}