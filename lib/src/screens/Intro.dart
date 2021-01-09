import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:mangoHub/src/shared/Repository.dart';


class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  Repository _repository = new Repository();

  Future<void> routePage() async{
    String _loginStatus = await _repository.readData('loginStatus');

    if(_loginStatus == 'alreadyLogin'){
      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Dashboard(),));

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
      });
    }
    else{
      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginUser(),));
      Navigator.pushNamedAndRemoveUntil(context, '/loginUser', (route) => false);

    }
  }

  @override
  void initState() {
    super.initState();
    routePage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 150.0,
          left: 50.0,
          right: 50.0,
          child: Image.asset("assets/images/logo.png",width: MediaQuery.of(context).size.width*0.7)
        ),
        Positioned(
          bottom: 10.0,
          child: Image.asset("assets/images/intro_background.png", width: MediaQuery.of(context).size.width),
        )

      ]
    );

  }
}

