import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangoHub/src/blocs/Authentication/authentication_bloc.dart';
import 'package:mangoHub/src/components/AlertBox.dart';
import 'package:mangoHub/src/components/Buttons.dart';
import 'package:mangoHub/src/components/LoaderForm.dart';
import 'package:mangoHub/src/components/TextFormField.dart';
import 'package:mangoHub/src/models/APImodels/AuthenticationModel.dart';
import 'package:mangoHub/src/screens/Dashboard.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:mangoHub/src/shared/Repository.dart';
import 'package:string_validator/string_validator.dart';

/*Login Page Completed */

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  String deviceName;
  String deviceVersion;
  String uid;

  bool _passwordVisible = false;
  bool loginFailedState = false;
  String errorMessage;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController loginUserName = TextEditingController();
  final TextEditingController password = TextEditingController();

  Repository _repository = new Repository();

  void _toggle1() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }
  Future closeLoader() async {
    return await Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    print("Login init state");
    getDeviceDetails();
  }


  Widget buildLoginUI(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: mangoGrey,
        body: GestureDetector(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  color: mangoOrange,
                  height: _size.height*0.45,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top: _size.height*0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/images/mangohub_logo.png", height: _size.height*0.15,),
                        SizedBox(height: _size.height*0.02,),
                        Text(
                          "Welcome to MangoHub",
                          style: TextStyle(fontSize: _size.height*0.04, color: mangoGrey, fontWeight: FontWeight.w400, letterSpacing: 1.2),
                        ),
                      ],
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
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SingleTextFormField(
                          inputText: loginUserName,
                          inputTextVisible: false,
                          labelText: "Username",
                          hintText: "Enter Your Email or Mobile No:",
                          iconButton: null,
                          textInputType: TextInputType.emailAddress,
                          validatorFunction: (value){
                            if(value.isEmpty){
                              return "Required";
                            }
                            // else if(isEmail(value) == false){
                            //   return "Invalid Email Type";
                            // }
                            else if(loginFailedState==true && matches(errorMessage, 'user')==true){
                              // email.clear();
                              return "Invalid User";
                            }
                          },
                        ),
                        SingleTextFormField(
                          inputText: password,
                          inputTextVisible: !_passwordVisible,
                          // labelText: "Password",
                          hintText: "Enter Your Password",
                          iconButton: IconButton(
                            icon: Icon(_passwordVisible == false
                                ? Icons.visibility
                                : Icons.visibility_off, color: mangoOrange,),
                            onPressed: (){
                              _toggle1();
                            },),
                          textInputType: TextInputType.text,
                          validatorFunction: (value){
                            if(value.isEmpty){
                              return "Required";
                            }
                            else if(loginFailedState==true && matches(errorMessage, 'password')==true){
                              // password.clear();
                              return "Invalid Password";
                            }
                          },
                        ),
                        FlatButtonComp(
                            text: "Login",
                            press: (){
                              loginFailedState = false;
                              errorMessage = "";
                              if(!_formKey.currentState.validate()){
                                return;
                              }
                              else {
                                var _newLoginUserName;
                                FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
                                LoaderFormState.showLoader(context, 'Please wait...');

                                  if(loginUserName.text[0] == '0' && loginUserName.text.length == 10){
                                    _newLoginUserName = loginUserName.text.replaceFirst(RegExp('0'), '+94');
                                    // _newLoginUserName = loginUserName.text; // remove this.............
                                  }
                                  else {
                                    _newLoginUserName = loginUserName.text;
                                  }
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                    GetLoginUserDetails(
                                        authentication: Authentication(
                                            login: Login(
                                              loginUserName: _newLoginUserName,
                                              loginPassword: password.text,
                                              loginUid: uid
                                            )
                                        )
                                    )
                                );
                              }
                            }
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: _size.height*0.3+300.0, left: _size.width*0.15, right: _size.width*0.15),
                  child: NamedButtonComp(
                      text: "I don't have an account",
                      press: () {
                        Navigator.pushNamed(context, '/signUpUser');
                      }
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: _size.height*0.25+530.0, left: _size.width*0.15, right: _size.width*0.15),
                  child: NamedButtonComp(
                      text: "I forgot password",
                      press: () {
                        Navigator.pushNamed(context, '/resetPassword');
                      }
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard when clicking outside TextField/anywhere on screen
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Login build state");

    return BlocListener<AuthenticationBloc,AuthenticationState>(
      listener: (context, state){
        if(state is LoginUserSuccess){
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          _repository.addValue('loginStatus', 'alreadyLogin');
            if(state.authentication.login.loginType.toLowerCase() == "driver" && state.authentication.login.loginStatus == false) {
              BlocProvider.of<AuthenticationBloc>(context).add(
                  GetMyProfile(token: state.authentication.token)
              );
            }
        }
        // if(state is LoginUserSuccess){
        //   FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
        //   if(state.authentication.login.loginType.toLowerCase() == "driver" && state.authentication.login.loginStatus == false){
        //   }
        // }
        if(state is LoginUserFailed){
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
          loginFailedState = true;
          errorMessage = state.authentication.msg;
          if(_formKey.currentState.validate()){
            return;
          }

          // showAlertDialog(context, 'Failed',errorMessage);
        }
        if(state is LoginUserFailedException){
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
          showAlertDialog(context, 'Failed',state.errorObject);
        }

        if(state is GetMyProfileSuccess){

          profileDetails.add(
              Authentication(
                  user: state.authentication.user
              )
          );
          LoaderFormState.hideLoader(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Dashboard(),));

        }
        if(state is GetMyProfileFailed){

        }
        if(state is GetMyProfileFailedException){

        }
      },

      child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
          builder: (context,state){
            return buildLoginUI(context);
          }
      ),
    );
  }

  getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        uid = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        uid = data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

}
