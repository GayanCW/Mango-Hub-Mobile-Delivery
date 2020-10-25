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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: CircularProgressIndicator(
                  backgroundColor: mangoOrange,
                ),
                // color: Colors.red,
                height: 60,
                width: 60,
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
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
