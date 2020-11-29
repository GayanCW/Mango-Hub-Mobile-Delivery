import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

// showAlertDialog(BuildContext context,String message) {
//
//   // set up the button
//   Widget okButton = FlatButton(
//     child: Text("Ok"),
//     onPressed: () {
//       FocusScope.of(context).requestFocus(FocusNode());
//     },
//   );
//   Widget cancleButton = FlatButton(
//     child: Text("Cancle"),
//     onPressed: () {
//       // Navigator.pop(context);
//       FocusScope.of(context).requestFocus(FocusNode());
//     },
//   );
//
//   AlertDialog alert = AlertDialog(// set up the AlertDialog
//     // title: Text("Testing"),
//     content: Text(message),
//     actions: [
//       cancleButton,
//       okButton,
//     ],
//   );
//   showDialog(   // show the dialog
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
//
// }

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

}
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

void showAlertDialog(BuildContext context, String header, String body) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return CupertinoAlertDialog(
          title: Text(header),
          content: Container(
            padding: EdgeInsets.only(bottom: 5, top: 10),
            child: Column(
              children: <Widget>[
                Container(padding: EdgeInsets.only(bottom: 7), child: Text(capitalize(body))),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Close'),
              textStyle: TextStyle(color: mangoOrange),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]);
    },
  );
}

showReceiptDialog(BuildContext context, String header, String paymentType, double amount, String invoiceId, String orderId) {
  // flutter defined function
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      final qrFutureBuilder = FutureBuilder(
        future: _loadOverlayImage(),
        builder: (ctx, snapshot) {
          final size = 150.0;
          if (!snapshot.hasData) {
            return Container(width: size, height: size);
          }
          return CustomPaint(
            size: Size.square(size),
            painter: QrPainter(
              data: invoiceId,
              version: QrVersions.auto,
              color: Colors.black,
              emptyColor: Colors.white,
              // size: 320.0,
              // embeddedImage: snapshot.data,
              // embeddedImageStyle: QrEmbeddedImageStyle(
              //   size: Size.square(60),
              // ),
            ),
          );
        },
      );
      return CupertinoAlertDialog(
          title: Text(header, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.grey[900]),),
          content: Container(
            height: 250,

            padding: EdgeInsets.only(bottom: 5, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(padding: EdgeInsets.only(bottom: 7), child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Payment Type', style: TextStyle(fontSize: 20, color: Colors.grey[900]),),
                    SizedBox(width: 10.0,),
                    Text(capitalize(paymentType),style: TextStyle(fontSize: 16, color: Colors.green),),
                  ],
                )),
                Container(padding: EdgeInsets.only(bottom: 7), child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Amount',style: TextStyle(fontSize: 20, color: Colors.grey[900]),),
                    SizedBox(width: 10.0,),
                    Text('Rs.'+oCcy.format(amount),style: TextStyle(fontSize: 16, color: Colors.green),),
                  ],
                )),
                /*Container(padding: EdgeInsets.only(bottom: 7), child: Row(
                  children: [
                    Text('Invoice ID'),
                    Text(capitalize(invoiceId)),
                  ],
                )),
                Container(padding: EdgeInsets.only(bottom: 7), child: Row(
                  children: [
                    Text('OrderId'),
                    Text(capitalize(orderId)),
                  ],
                )),*/
                SizedBox(height: 20.0,),
                Container(
                  child: qrFutureBuilder,
                )
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Close'),
              textStyle: TextStyle(color: mangoOrange),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]);
    },
  );
}

Future<ui.Image> _loadOverlayImage() async {
  final completer = Completer<ui.Image>();
  final byteData = await rootBundle.load('assets/images/mangohub_logo.png');
  ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
  return completer.future;
}





