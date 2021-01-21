import 'package:flutter/material.dart';
import 'package:mangoHub/src/shared/Colors.dart';

class LoaderForm extends StatefulWidget {
  @override
  LoaderFormState createState() => LoaderFormState();
}

class LoaderFormState extends State<LoaderForm> {

  static showLoader(BuildContext context, String message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0), bottom: Radius.circular(30.0)),
            child: Container(
              height: 60,
              width: 50,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                    ),
                    // color: Colors.red,
                    height: 30,
                    width: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,top: 10),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  static hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .pop(); //close loader without page routing. if(rootNavigator: false==> page routing true)
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
