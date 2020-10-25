import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangoHub/src/blocs/SignUp/signUp_bloc.dart';
import 'package:mangoHub/src/components/AlertBox.dart';
import 'package:mangoHub/src/components/Buttons.dart';
import 'package:mangoHub/src/components/LoaderForm.dart';
import 'package:mangoHub/src/components/TextFormField.dart';
import 'package:mangoHub/src/models/UImodels/District.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:string_validator/string_validator.dart';
import 'package:image_picker/image_picker.dart';

/* SignUp Page Completed */

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _reEnteredPasswordVisible = false;
  String selectedDistrict;
  String selectedCity;
  List<String> districtsList = [];
  List<String> citiesList = [];

  int pageIndex=0;
  File _image;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController reEnteredPassword = TextEditingController();

  final TextEditingController addressLine1 = TextEditingController();
  final TextEditingController addressLine2 = TextEditingController();
  // final TextEditingController district = TextEditingController();
  // final TextEditingController city = TextEditingController();
  final TextEditingController zipCode = TextEditingController();

  final TextEditingController mobileNum = TextEditingController();

  final PageController _pageController = PageController(
    initialPage: 0
  );


  void _toggle1() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }
  void _toggle2() {
    setState(() {
      _reEnteredPasswordVisible = !_reEnteredPasswordVisible;
    });
  }
  void _onPageChanged(int value) {
    setState(() {
      pageIndex = value;
    });
  }

  Future<dynamic> _getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("image:");
      print(_image);
    });
  }

  Future<LocalDistricts> loadDistricts() async {
    var response = jsonDecode(
        await rootBundle.loadString('assets/District.json'));
    LocalDistricts loadedDistricts = new LocalDistricts();
    loadedDistricts = LocalDistricts.fromJson(response);

    for (int i = 0; i < loadedDistricts.districts.length; i++) {
      districtsList.add(loadedDistricts.districts[i].district);
    }
    // districtsList.sort((A,Z)=>A.compareTo(Z));
    return loadedDistricts;
  }

  Future<LocalDistricts> loadCities(int districtIndex) async {
    var response = jsonDecode(
        await rootBundle.loadString('assets/District.json'));
    LocalDistricts loadedCities = new LocalDistricts();
    loadedCities = LocalDistricts.fromJson(response);

    for (int j=0; j<loadedCities.districts[districtIndex].city.length; j++){
      citiesList.add(loadedCities.districts[districtIndex].city[j]);
    }
    // citiesList.sort((A,Z)=>A.compareTo(Z));

    return loadedCities;
  }

  Future closeLoader() async {
    return await Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    loadDistricts();
    print("SignUp init state");
  }

  void goBack(){
    setState(() {
      Navigator.pop(context);
    });
  }

  Widget buildSignUp(BuildContext context) {
   Size _size = MediaQuery.of(context).size;

   List<Widget> widgetSliders = [
     Form(
       key: _formKey,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           SingleTextFormField(
             inputText: firstName,
             inputTextVisible: false,
             labelText: "First Name",
             hintText: "Enter Your FirstName",
             iconButton: null,
             textInputType: TextInputType.name,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
               if(isAlpha(value) == false){
                 return "invalid name type";
               }
             },
           ),
           SingleTextFormField(
             inputText: lastName,
             inputTextVisible: false,
             labelText: "Last Name",
             hintText: "Enter Your LastName",
             iconButton: null,
             textInputType: TextInputType.name,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
               if(isAlpha(value) == false){
                 return "invalid name type";
               }
             },
           ),
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
               if(isEmail(value) == false){
                 return "invalid Email type";
               }
             },
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
                 _toggle1();
               },),
             textInputType: TextInputType.text,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
             },
           ),
           SingleTextFormField(
             inputText: reEnteredPassword,
             inputTextVisible: !_reEnteredPasswordVisible,
             labelText: "Conform Password",
             hintText: "Re-Enter Your Password",
             iconButton: IconButton(
               icon: Icon(_reEnteredPasswordVisible == false
                   ? Icons.visibility_off
                   : Icons.visibility),
               onPressed: (){
                 // _toggle2();
               },),
             textInputType: TextInputType.text,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
               else if(equals(reEnteredPassword.text, password.text) == false){
                 return "Doesn't Match new Password";
               }
             },
           ),
         ],
       ),
     ),
     Form(
       key: _formKey,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           SingleTextFormField(
             inputText: addressLine1,
             inputTextVisible: false,
             labelText: "address_line1",
             hintText: "Enter Your address_line1",
             iconButton: null,
             textInputType: TextInputType.text,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
             },
           ),
           SingleTextFormField(
             inputText: addressLine2,
             inputTextVisible: false,
             labelText: "address_line2",
             hintText: "Enter Your address_line2", // not required
             iconButton: null,
           ),
           /*SingleTextFormField(
             inputText: district,
             labelText: "District",
             inputTextVisible: false,
             hintText: "Enter Your District",
             iconButton: IconButton(
                 icon: Icon(Icons.arrow_drop_down),
                 onPressed: (){

                 }
             ),
             textInputType: TextInputType.text,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
             },
           ),
           SingleTextFormField(
             inputText: city,
             inputTextVisible: false,
             labelText: "City",
             hintText: "Enter Your City", // not required
             iconButton: null,
             textInputType: TextInputType.text,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
             },
           ),*/
           Container(
             height: 85.0,
             child: DropdownSearch<String>(
               validator: (v) => v == null ? "Required" : null,
               hint: "Select a district",
               mode: Mode.DIALOG,
               selectedItem: selectedDistrict,
               showSelectedItem: true,
               items: districtsList,
               // label: (selectedDistrict==" ")?"Districts":selectedDistrict,
               showClearButton: true,
               showSearchBox: true,
               onChanged: (value){
                 selectedDistrict = value;
                 selectedCity = null;
                 citiesList.clear();
                 loadCities(districtsList.indexOf(value));
               },

             ),
           ),
           Container(
             height: 85.0,
             child: DropdownSearch<String>(
               validator: (v) => v == null ? "Required" : null,
               hint: "Select a city",
               mode: Mode.DIALOG,
               selectedItem: selectedCity,
               showSelectedItem: true,
               items: citiesList,
               // label: (selectedCity==" ")?"Cities":selectedCity,
               showClearButton: true,
               showSearchBox: true,
               onChanged: (value){
                 selectedCity = value;
               },
             ),
           ),
           SingleTextFormField(
             inputText: zipCode,
             inputTextVisible: false,
             labelText: "Zip_code",
             hintText: "Zip_code", // not required
             iconButton: null,
             textInputType: TextInputType.number,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
             },
           ),

         ],
       ),
     ),
     Form(
       key: _formKey,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           SingleTextFormField(
             maxLength: 10,
             inputText: mobileNum,
             labelText: "Mobile Number",
             inputTextVisible: false,
             hintText: "07x xxxxxxx",
             iconButton: null,
             textInputType: TextInputType.phone,
             validatorFunction: (value){
               if(value.isEmpty){
                 return "Required";
               }
               else if((mobileNum.text[0] != '0' || mobileNum.text[1] != '7') || (mobileNum.text[0] != '0' && mobileNum.text[1] != '7') ){
                 return "Error Number";
               }
               else if(isLength(mobileNum.text, 10,10) == false){
                 return "Error Length";
               }

             },
           ),
           FlatButton(
             onPressed: _getImage,
             child: (_image==null)? Icon(
               Icons.image,
               size: 80,
             ): Image.file(
               _image,
               fit: BoxFit.cover,
               height: 150,
               // width: _size.width*0.5,
             ),
           ),
           SizedBox(
             height: _size.height*0.02,
           ),
           FlatButtonComp(
               text: "Register",
               press: () {
                 LoginUser _loginUser =  new LoginUser(
                   loginEmail: email.text,
                   loginPassword: password.text,
                   loginCompanies: [],
                   loginType: "driver",
                   loginRole: "member",
                   loginStatus: false,
                   loginStatusString: "pending",
                   userProfileId: ""
                 );
                 UserAddress _userAddress = new UserAddress(
                   addressLine1: addressLine1.text,
                   addressLine2: addressLine2.text,
                   country: "Sri lanka",
                   city: selectedCity,
                   district: selectedDistrict,
                   zipCode: zipCode.text
                 );
                 User _user = new User(
                   userFirstName: firstName.text,
                   userLastName: lastName.text,
                   userImage:"",
                   userAddress: _userAddress,
                   userReferenceId: "",
                   userReference: false,
                   userStatusString: "pending",
                   userStatus: true, //need to change this to false.. aniwa hodeeee
                   userMobile: mobileNum.text,
                 );

                 // print(_user.userMobile);
                 // print(_user.userAddress.zipCode);
                 // print(_loginUser.loginPassword);

                 if(!_formKey.currentState.validate()){
                   return;
                 }
                 else{
                   FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
                   LoaderFormState.showLoader(context, 'Please wait...');
                   BlocProvider.of<SignUpBloc>(context).add(
                       GetSignUpDetails(
                           login: _loginUser,
                           user: _user
                       )
                   );
                 }
               }
           ),
         ],
       ),
     ),
   ];


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignUp Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: GestureDetector(  // GestureDetector use for hide soft input keyboard after clicking outside TextField/anywhere on screen
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  color: mangoOrange,
                  height: _size.height*0.35,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        "Create Your Account",
                        style: TextStyle(fontSize: _size.height*0.04, color: mangoWhite),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  margin: EdgeInsets.only(
                    top: _size.height*0.28,
                    left: _size.width*0.06,
                    right: _size.width*0.06,
                  ),
                  padding: EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: mangoShadow,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                        ),
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        // color: Colors.blue,
                        height: 440.0,
                        margin: EdgeInsets.symmetric(horizontal: _size.width*0.05),
                        child: PageView(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged:_onPageChanged,
                           children: [
                             widgetSliders[pageIndex],
                           ],
                        ),
                      ),
                      Container(
                        // color: Colors.orange,
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: _size.width*0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: (pageIndex>0 && pageIndex<=widgetSliders.length)?NamedButtonComp(
                                  text: "< Back",
                                  press: () {
                                    _formKey.currentState.reset();  // reset validation
                                    TextEditingController().clear();
                                    setState(() {
                                      FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
                                      pageIndex--;
                                    });
                                  }
                              ):null,
                            ),
                            Container(
                              child: (pageIndex>=0 && pageIndex<widgetSliders.length-1)?NamedButtonComp(
                                  text: "Next >",
                                  press: () {
                                    if(!_formKey.currentState.validate()){
                                      return;
                                    }
                                    else {
                                      setState(() {
                                        FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
                                        pageIndex++;
                                      });
                                    }
                                  }
                              ): null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: _size.height*0.84+40.0, left: _size.width*0.15, right: _size.width*0.15),
                  child: NamedButtonComp(
                      text: "I have an account",
                      press: () {
                        // Navigator.pushNamedAndRemoveUntil(context, '/myApp', (route) => false);
                        Navigator.pop(context);
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
    print("SignUp build state");
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state){
          if(state is SignUpSuccess){
            FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
            LoaderFormState.hideLoader(context);
                if(state.signUpUser.success == true){
                    print("Email: ${state.signUpUser.login.loginEmail}");
                    print("ProfileId: ${state.signUpUser.login.userProfileId}");
                    print("loginStates: ${state.signUpUser.login.loginStatus}");
                    print("loginStatusString: ${state.signUpUser.login.loginStatusString}");
                    print("SignUp Success");
                    goBack();
                    showAlertDialogWithPop(context, "SignUp Success");
                }
                if(state.signUpUser.success == false){
                    print("Success: ${state.signUpUser.success}");
                    print("Exist: ${state.signUpUser.exist}");
                    print("You Already SignIn ");
                    goBack();
                    showAlertDialogWithPop(context, "You Already SignIn");
                }
          }
          if(state is SignUpFailed){

          }
          if(state is SignUpFailedException){
            FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
            LoaderFormState.hideLoader(context);
            showAlertDialog(context, state.errorObject);
          }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state){
          return buildSignUp(context);
        },
      ),
    );
  }

}

/*********************************************************************************************/

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {

  File _image;

  Future<dynamic> _getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print(_image);
    });
  }


  @override
  Widget build(BuildContext context) {
    return null;
  }
}

