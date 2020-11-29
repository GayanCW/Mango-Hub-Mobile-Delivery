import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mangoHub/src/screens/Dashboard.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:mangoHub/src/shared/Repository.dart';
import 'Login.dart';



class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  Location location = Location();

  Repository _repository = new Repository();

  Future<void> routePage() async{
    String _loginStatus = await _repository.readData('loginStatus');

    if(_loginStatus == 'alreadyLogin'){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Dashboard(),));
    }
    else{
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Login(),));
    }
  }

  Future<void> getLocationPermission() async{
    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled == true) {
      routePage();
    }
  }

  @override
  void initState() {
    super.initState();
    routePage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'MangoHub Mobile Delivery',
        style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.w800, color: mangoOrange, ),
        textAlign: TextAlign.center,
      ),
    );

  }
}

