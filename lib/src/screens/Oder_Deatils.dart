import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OderDeatils extends StatefulWidget {
  @override
  _OderDeatilsState createState() => _OderDeatilsState();
}

class _OderDeatilsState extends State<OderDeatils> {
  bool selectOderdItem = true;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar:AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange,
        leading:
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 21,
          icon: Icon(Icons.arrow_back, color: Colors.white,),

        ),
        title:
        Text("Oder Deatils",),
        actions:  <Widget>[
          IconButton(
            onPressed: () {},
            iconSize: 21,
            icon: Icon(Icons.notifications_active, color: Colors.white,),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                    gradient: LinearGradient( colors: [
                      Colors.pink,
                      Colors.red,
                      Colors.green,
                      Colors.purple,
                      Colors.teal
                    ],)
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                        width: 50,
                      ),
                      RaisedButton(
                          color: selectOderdItem ? Colors.red:Colors.white,
                          child: Text("Odered Item"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          elevation: 5,
                          onPressed: (){
                            setState(() {
                              selectOderdItem=true;
                            });
                          }),
                      SizedBox(
                        height: 40,
                        width: 80,
                      ),
                      RaisedButton(

                          color:selectOderdItem ? Colors.white:Colors.red,
                          child: Text("Customer"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          elevation: 5,
                          onPressed: (){
                            setState(() {
                              selectOderdItem=false;
                            });
                          }),

                    ],
                  ),
                  selectOderdItem ?
                  oderedItembuttoncontainer():customerbuttoncontainer(),

                ],
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                    gradient: LinearGradient( colors: [
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.orangeAccent,
                      Colors.orange,
                      Colors.deepOrange,
                    ],)
                ),
              ),
            ],
          )
        ],
      ),


    );
    
  }
}

class oderedItembuttoncontainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.only(left: 10),
                    child: Image(
                      image: AssetImage("assets/images/keerisambapro.png"),)),
                SizedBox(
                  height: 100,
                  width: 30,
                ),
                Container(
                  height: 100,
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Araliya kiri samba",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                      Text("Cragills Food city"),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 30,right: 10),
                    child: Text("LKR: 250.00",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),))

              ],
            ),
          ),
          Container(
            height: 100,
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.only(left: 10),
                    child: Image(
                      image: AssetImage("lib/Asserts/reddhal.png"),)),
                SizedBox(
                  height: 100,
                  width: 30,
                ),
                Container(
                  height: 100,
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Red dhal",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                      Text("Cragills Food city"),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 30,right: 10),
                    child: Text("LKR: 150.00",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),))

              ],
            ),
          ),

        ],
      ),
    );
  }
}
class customerbuttoncontainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 20,
                        width: 100,
                        padding: EdgeInsets.only(left: 19),
                        child: Text("full name",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),)),
                    Container(
                        height: 20,
                        width: 150,
                        padding: EdgeInsets.only(left: 19),
                        child: Text("Dinesh madushan",style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.person,size: 40,)),
              ],
            ),
          ),
          Container(
            height: 100,
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 20,
                        width: 150,
                        padding: EdgeInsets.only(left: 19),
                        child: Text("Delivery Address",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),)),
                    Container(
                        height: 20,
                        width: 150,
                        padding: EdgeInsets.only(left: 19),
                        child: Text("zzzzzzzzz",style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),)),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.perm_contact_calendar,size: 40,)),
              ],
            ),
          ),
          Container(
            height: 100,
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 20,
                        width: 150,
                        padding: EdgeInsets.only(left: 19),
                        child: Text("Phone number",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),)),
                    Container(
                        height: 20,
                        width: 150,
                        padding: EdgeInsets.only(left: 19),
                        child: Text("53637262781816",style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),)),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.call,size: 40,)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


