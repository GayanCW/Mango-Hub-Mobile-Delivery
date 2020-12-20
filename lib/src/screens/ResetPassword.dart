import 'package:flutter/material.dart';
import 'package:mangoHub/src/components/Buttons.dart';
import 'package:mangoHub/src/components/TextFormField.dart';
import 'package:mangoHub/src/shared/Colors.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController mobileNum = TextEditingController();

  void validate() {
    if (_formKey.currentState.validate()) {
      print("validated");
    } else {
      print("Not Validated");
    }
  }

  @override
  Widget build(BuildContext context) {
   Size _size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: mangoGrey,
        body: GestureDetector(  // GestureDetector use for hide soft input keyboard after clicking outside TextField/anywhere on screen
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  color: mangoOrange,
                  height: _size.height*0.45,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: _size.height*0.2),
                    child: Text(
                      "Reset Password",
                      style: TextStyle(fontSize: _size.height*0.04, color: mangoGrey, fontWeight: FontWeight.w400, letterSpacing: 1.2),
                    ),
                  ),
                ),
                Container(
                  // height: _size.height*0.4,
                  height: 280.0,
                  margin: EdgeInsets.only(
                    top: _size.height*0.3,
                    left: _size.width*0.06,
                    right: _size.width*0.06,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      color: mangoWhite,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: mangoWhite,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                  child: Form(
                    child: Column(
                      key: _formKey,
                      // autovalidate: true,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SingleTextFormField(
                          inputText: mobileNum,
                          labelText: "Mobile Number",
                          inputTextVisible: true,
                          hintText: "+94 xx xxxxxxx",
                          iconButton: null,
                        ),
                        SizedBox(
                          height: _size.height*0.02,
                        ),
                        FlatButtonComp(
                          text: "Send link",
                          press: (){},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: _size.height*0.25+530.0, left: _size.width*0.15, right: _size.width*0.15),
                  child: NamedButtonComp(
                      text: "I remember my password",
                      press: () {
                        Navigator.pop(context);
                      }
                  ),
                ),
                /*Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: _size.height*0.84+40.0, left: _size.width*0.15, right: _size.width*0.15),
                  child: NamedButtonComp(
                      text: "I don't have an account",
                      press: () {
                        Navigator.pushNamed(context, '/SignUp');
                      }
                  ),
                ),*/

              ],
            ),
          ),
          onTap: () {
            //  hide keyboard when clicking outside TextField/anywhere on screen
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    );
  }
}
