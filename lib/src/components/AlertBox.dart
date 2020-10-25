import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlertDialog(BuildContext context,String message) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      FocusScope.of(context).requestFocus(FocusNode());
    },
  );
  Widget cancleButton = FlatButton(
    child: Text("Cancle"),
    onPressed: () {
      // Navigator.pop(context);
      FocusScope.of(context).requestFocus(FocusNode());
    },
  );

  AlertDialog alert = AlertDialog(// set up the AlertDialog
    // title: Text("Testing"),
    content: Text(message),
    actions: [
      cancleButton,
      okButton,
    ],
  );
  showDialog(   // show the dialog
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}

showAlertDialogWithPop(BuildContext context,String message)async{

  AlertDialog alert = AlertDialog(// set up the AlertDialog
    // title: Text("Testing"),
    content: Text(message),
  );
  showDialog(   // show the dialog
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  // await Future.delayed(Duration(seconds: 3), () {
  //   // Navigator.pushNamedAndRemoveUntil(context, routePath, (route) => false);
  //   Navigator.pop(context);
  // });

}

