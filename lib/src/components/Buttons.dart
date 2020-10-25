import 'package:flutter/material.dart';
import 'package:mangoHub/src/shared/Colors.dart';

// ignore: must_be_immutable
class FlatButtonComp extends StatelessWidget {
  String text;
  Function press;

  FlatButtonComp({this.text, this.press});

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return FlatButton(
        color: mangoOrange,
        splashColor: Colors.orange,
        disabledColor: mangoOrange,
        child: Container(
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: mangoWhite, fontSize: _size.height*0.02),
            ),
          ),
        ),
        onPressed: press,
    );
  }
}


Widget flatButtonComp2(BuildContext context,String text,Function press) {
  Size _size = MediaQuery
      .of(context)
      .size;

  return FlatButton(
    color: mangoOrange,
    splashColor: Colors.orange,
    disabledColor: mangoOrange,
    child: Container(
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: mangoWhite, fontSize: _size.height * 0.02),
        ),
      ),
    ),
    onPressed: press,
  );
}


// ignore: must_be_immutable
class NamedButtonComp extends StatelessWidget {
  String text;
  Function press;

  NamedButtonComp({this.text, this.press});

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return FlatButton(
      color: Colors.white12,
      splashColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.black54, fontSize: _size.height*0.019),
        ),
      ),
      onPressed: press,
    );
  }
}
