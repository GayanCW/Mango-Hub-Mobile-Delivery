import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangoHub/src/shared/Colors.dart';

class ProfileScreen extends StatefulWidget {
  final String pageTitle;

  ProfileScreen({Key key, this.pageTitle}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: mangoGrey,
        appBar: AppBar(
          title: Text(
            "About me".toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: mangoWhite)
          ),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.notifications_active,
                  size: 25.0,
                ),
                onPressed: () {}),
          ],
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: mangoOrange,
          elevation: 0,
        ),
        body: GestureDetector(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Container(
                  height: 250,
                  color: mangoOrange,
                ),
                Container(
                  margin: EdgeInsets.only(top: 150.0),
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 80,
                    left: 10.0,
                    right: 10.0,
                  ),
                  decoration: BoxDecoration(
                      color: mangoGrey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0))),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'mango Driver',
                        style: TextStyle(
                            fontSize: 38.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins', color: mangoOrange),
                      ),
                      SizedBox(height: 20.0,),
                      Text('Address', style: h4),
                      Text("No.537,",style: h5,),
                      Text("Old Galle Road,",style: h5,),
                      Text("Moratuwa,",style: h5,),
                      Text("Sri Lanka.",style: h5,),
                      SizedBox(height: 20.0,),
                      Text('First Name', style: h4),
                      Text("Mango",style: h5,),
                      SizedBox(height: 20.0,),
                      Text('Last Name', style: h4),
                      Text("Driver",style: h5,),
                      SizedBox(height: 20.0,),
                      Text('Email', style: h4),
                      Text("drivar01@mangohub.com",style: h5,),
                      SizedBox(height: 20.0,),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: EdgeInsets.only(top: 5.0),
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                          color: mangoOrange,
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/delivery-man2.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(100.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 5.0, color: Colors.grey)
                          ])),
                ),
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(
                FocusNode()); //  hide keyboard when clicking outside TextField/anywhere on screen
          },
        ),
      );

  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height / 2.7);
    path.lineTo(size.width + 120, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

TextStyle h4 = TextStyle(
    color: mangoOrange,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins');

TextStyle h5 = TextStyle(
    color: mangoWhite,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    fontFamily: 'Poppins');
