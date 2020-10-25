import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangoHub/src/blocs/Login/login_bloc.dart';
import 'package:mangoHub/src/components/AlertBox.dart';
import 'package:mangoHub/src/components/Buttons.dart';
import 'package:mangoHub/src/components/LoaderForm.dart';
import 'package:mangoHub/src/components/TextFormField.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:string_validator/string_validator.dart';
import 'Intro.dart';

/*Login Page Completed */

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;
  bool loginFailedState = false;
  String errorMessage;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
  }


  Widget buildLoginUI(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            color: mangoOrange,
            height: _size.height*0.35,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  "Let's Start with Login!",
                  style: TextStyle(fontSize: _size.height*0.04, color: mangoWhite),
                ),
              ),
            ),
          ),
          Container(
            // height: _size.height*0.4,
            height: 340.0,
            margin: EdgeInsets.only(
              top: _size.height*0.28,
              left: _size.width*0.06,
              right: _size.width*0.06,
            ),
            padding: EdgeInsets.symmetric(horizontal: _size.width*0.05),
            decoration: BoxDecoration(
                color: mangoWhite,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: mangoShadow,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 10.0,
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
                    inputText: email,
                    inputTextVisible: false,
                    labelText: "Username",
                    hintText: "Enter Your Email",
                    iconButton: null,
                    textInputType: TextInputType.emailAddress,
                    validatorFunction: (value){
                      if(value.isEmpty){
                        return "Required";
                      }
                      else if(isEmail(value) == false){
                        return "Invalid Email Type";
                      }
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
                          ? Icons.visibility_off
                          : Icons.visibility),
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
                  SizedBox(
                    height: _size.height*0.02,
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
                        FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
                        LoaderFormState.showLoader(context, 'Please wait...');
                        BlocProvider.of<LoginBloc>(context).add(
                          GetLoginDetails(email: email.text, password: password.text));
                      }
                    }
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: _size.height*0.84, left: _size.width*0.15, right: _size.width*0.15),
            child: NamedButtonComp(
                text: "I forgot password",
                press: () {
                  Navigator.pushNamed(context, '/resetPassword');
                }
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: _size.height*0.84+40.0, left: _size.width*0.15, right: _size.width*0.15),
            child: NamedButtonComp(
                text: "I don't have an account",
                press: () {
                  Navigator.pushNamed(context, '/signUp');
                }
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Login build state");

    return BlocListener<LoginBloc,LoginState>(
      listener: (context, state){
        if(state is LoginSuccess){
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
            if(state.loginUser.login.loginType == "driver" && state.loginUser.login.loginStatus == false){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Tabs(pageTitle: 'MangoHub'),));
            }
        }
        else if(state is LoginFailed){
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
            loginFailedState = true;
            errorMessage = state.loginUser.msg;
            if(_formKey.currentState.validate()){
              return;
            }
            // showAlertDialog(context, state.loginUser.msg);
        }
        else if(state is LoginFailedException){
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
          showAlertDialog(context, state.errorObject);

        }
      },

      child: BlocBuilder<LoginBloc,LoginState>(
          builder: (context,state){
            return buildLoginUI(context);
          }
      ),
    );
  }

}
