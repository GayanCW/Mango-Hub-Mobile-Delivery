import 'package:flutter/material.dart';
import 'package:mangoHub/src/components/TextFormField.dart';

class SlideItems extends StatefulWidget {
  @override
  _SlideItemsState createState() => _SlideItemsState();
}

class _SlideItemsState extends State<SlideItems> {


  bool _passwordVisible = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fullName = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobileNum = TextEditingController();
  final TextEditingController password = TextEditingController();

  void _toggle() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery
        .of(context)
        .size;

    List<Widget> sliders = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SingleTextFormField(
            inputText: firstName,
            inputTextVisible: true,
            labelText: "First Name",
            hintText: "Enter Your FirstName",
            iconButton: null,
          ),
          SizedBox(
            height: _size.height*0.02,
          ),
          SingleTextFormField(
            inputText: lastName,
            inputTextVisible: true,
            labelText: "Last Name",
            hintText: "Enter Your LastName",
            iconButton: null,
          ),
          SizedBox(
            height: _size.height*0.02,
          ),
          SingleTextFormField(
            inputText: email,
            inputTextVisible: true,
            labelText: "Username",
            hintText: "Enter Your Email",
            iconButton: null,
          ),
          SizedBox(
            height: _size.height*0.02,
          ),
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
          SingleTextFormField(
            inputText: password,
            inputTextVisible: !_passwordVisible,
            labelText: "Password",
            hintText: "Enter Your Password",
            iconButton: IconButton(
              icon: Icon(_passwordVisible == false
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: (){
                _toggle();
              },),
          ),
        ],
      ),

      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SingleTextFormField(
            inputText: firstName,
            inputTextVisible: true,
            labelText: "First Name",
            hintText: "Enter Your FirstName",
            iconButton: null,
          ),
          SizedBox(
            height: _size.height*0.02,
          ),
          SingleTextFormField(
            inputText: lastName,
            inputTextVisible: true,
            labelText: "Last Name",
            hintText: "Enter Your LastName",
            iconButton: null,
          ),
          SizedBox(
            height: _size.height*0.02,
          ),
          SingleTextFormField(
            inputText: email,
            inputTextVisible: true,
            labelText: "Username",
            hintText: "Enter Your Email",
            iconButton: null,
          ),
          SizedBox(
            height: _size.height*0.02,
          ),
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
          SingleTextFormField(
            inputText: password,
            inputTextVisible: !_passwordVisible,
            labelText: "Password",
            hintText: "Enter Your Password",
            iconButton: IconButton(
              icon: Icon(_passwordVisible == false
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: (){
                _toggle();
              },),
          ),
        ],
      ),
    ];

    return sliders[0];

  }

}
