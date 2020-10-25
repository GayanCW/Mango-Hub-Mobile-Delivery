import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangoHub/src/shared/Colors.dart';


// ignore: must_be_immutable
class SingleTextFormField extends StatefulWidget {
  var inputText;
  bool inputTextVisible;
  TextInputType textInputType;
  String labelText;
  String hintText;
  IconButton iconButton;
  Function validatorFunction;
  int maxLength;

  SingleTextFormField({
    this.inputText,
    this.inputTextVisible,
    this.textInputType,
    this.labelText,
    this.hintText,
    this.iconButton,
    this.validatorFunction,
    this.maxLength
  });

  @override
  _SingleTextFormFieldState createState() => _SingleTextFormFieldState();
}

class _SingleTextFormFieldState extends State<SingleTextFormField> {

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      height: 85,
      child: TextFormField(
          maxLength: widget.maxLength,
          controller: widget.inputText,
          obscureText: widget.inputTextVisible,
          keyboardType: widget.textInputType,
          decoration: InputDecoration(
            counterText: "",
            // labelText: widget.labelText,
            hintText: widget.hintText,
            suffixIcon: widget.iconButton,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mangoOrange),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mangoBlue),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mangoRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mangoBlue),
            ),
          ),
          validator: widget.validatorFunction,
        ),
    );
  }
}

/**********************************************************************************************/

// ignore: must_be_immutable
class SingleEditTextFormField extends StatefulWidget {

  var inputText;
  TextInputType textInputType;
  String title;
  String hintText;
  Function validatorFunction;
  int maxLength;

  SingleEditTextFormField({
    this.inputText,
    this.textInputType,
    this.title,
    this.hintText,
    this.validatorFunction,
    this.maxLength
  });
  @override
  _SingleEditTextFormFieldState createState() => _SingleEditTextFormFieldState();
}

class _SingleEditTextFormFieldState extends State<SingleEditTextFormField> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.purple,
      height: 100,
      margin: EdgeInsets.only(top: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 18.0, color: mangoText),
          ),
          // SizedBox(
          //   height: 5.0,
          // ),
          TextFormField(
            maxLength: widget.maxLength,
            controller: widget.inputText,
            keyboardType: widget.textInputType,
            decoration: InputDecoration(
              counterText: "",
              hintText: widget.hintText,
              hintStyle: TextStyle(color: mangoWhite),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mangoOrange),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mangoBlue),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mangoRed),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mangoBlue),
              ),
            ),
            validator: widget.validatorFunction,
          ),
        ],
      ),
    );
  }
}

