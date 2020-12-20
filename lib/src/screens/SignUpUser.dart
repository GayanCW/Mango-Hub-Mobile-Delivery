import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangoHub/src/blocs/Authentication/authentication_bloc.dart';
import 'package:mangoHub/src/components/AlertBox.dart';
import 'package:mangoHub/src/components/Buttons.dart';
import 'package:mangoHub/src/components/LoaderForm.dart';
import 'package:mangoHub/src/components/TextFormField.dart';
import 'package:mangoHub/src/models/APImodels/AuthenticationModel.dart';
import 'package:mangoHub/src/models/UImodels/District.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:string_validator/string_validator.dart';
import 'package:image_picker/image_picker.dart';

/* SignUp Page Completed */

class SignUpUser extends StatefulWidget {
  @override
  _SignUpUserState createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  String deviceName;
  String deviceVersion;
  String uid;

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
  final TextEditingController zipCode = TextEditingController();

  final TextEditingController mobileNum = TextEditingController();
  final TextEditingController nicNum = TextEditingController();
  final TextEditingController drivingLicenceNum = TextEditingController();

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
    getDeviceDetails();
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
                    : Icons.visibility,),
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
              maxLength: 12,
              inputText: mobileNum,
              labelText: "Mobile Number",
              inputTextVisible: false,
              hintText: "+94xxxxxxxxx",
              iconButton: null,
              textInputType: TextInputType.phone,
              validatorFunction: (value){
                if(value.isEmpty){
                  return "Required";
                }
                else if(mobileNum.text.length < 12){
                  if(mobileNum.text.length == 11){
                    return "Invalid Number";
                  }
                  if(mobileNum.text.length < 10){
                    return "Error Length";
                  }
                  if(mobileNum.text.length == 10){
                    if(mobileNum.text.substring(0,2) != '07'){
                      return "Invalid Number";
                    }
                  }
                }

                else if(mobileNum.text.length == 12){
                  if(mobileNum.text.substring(0,4) != '+947'){
                    return "Invalid Number";
                  }
                }

              },
            ),
            SingleTextFormField(
              maxLength: 11,
              inputText: nicNum,
              labelText: "NIC Number",
              inputTextVisible: false,
              hintText: "Your NIC Number",
              iconButton: null,
              textInputType: TextInputType.text,
              validatorFunction: (value){
                if(value.isEmpty){
                  return "Required";
                }
                else if(nicNum.text.length < 11){
                  if(nicNum.text.length < 10){
                    return "Error Length";
                  }
                  if(nicNum.text.length == 10){
                    if(nicNum.text.substring(9).toLowerCase() != 'v'){
                      return "Invalid Number";
                    }
                  }
                }
              },
            ),
            SingleTextFormField(
              maxLength: 11,
              inputText: drivingLicenceNum,
              labelText: "LICENCE Number",
              inputTextVisible: false,
              hintText: "Your Driving LICENCE Number",
              iconButton: null,
              textInputType: TextInputType.text,
              validatorFunction: (value){
                if(value.isEmpty){
                  return "Required";
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
                  if(!_formKey.currentState.validate()){
                    return;
                  }
                  else{
                    var _newMobileNum;
                    FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
                    LoaderFormState.showLoader(context, 'Please wait...');
                    if(mobileNum.text[0] == '0' && mobileNum.text.length == 10){
                      _newMobileNum = mobileNum.text.replaceFirst(RegExp('0'), '+94');
                    }
                    else {
                      _newMobileNum = mobileNum.text;
                    }

                    BlocProvider.of<AuthenticationBloc>(context).add(
                        GetSignUpUserDetails(
                            authentication: Authentication(
                                login: Login(
                                    loginEmail: email.text,
                                    loginEmailVerification: true,
                                    loginMobile: _newMobileNum,
                                    loginMobileVerification: true,
                                    loginPassword: password.text,
                                    loginType: "driver",
                                    loginRole: "member",
                                    loginStatus: "true",
                                    loginStatusString: "Active",
                                    loginCompanies: [],
                                    loginUid: uid,
                                    userProfileId: ""
                                ),
                                user: User(
                                  userFirstName: firstName.text,
                                  userLastName: lastName.text,
                                  userImage:"",
                                  userAddress: UserAddress(
                                      addressLine1: addressLine1.text,
                                      addressLine2: addressLine2.text,
                                      country: "Sri lanka",
                                      city: selectedCity,
                                      district: selectedDistrict,
                                      zipCode: int.parse(zipCode.text)
                                  ),
                                  userReferenceId: "",
                                  userReference: "true",
                                  userStatusString: "Active",
                                  userStatus: true, //need to change this to false.. aniwa hodeeee
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
    ];


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignUp Page',
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
                    padding: EdgeInsets.only(top: _size.height*0.125),
                    child: Text(
                      "Create Your Account",
                      style: TextStyle(fontSize: _size.height*0.04, color: mangoGrey, fontWeight: FontWeight.w400, letterSpacing: 1.2),
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  margin: EdgeInsets.only(
                    top: _size.height*0.25,
                    left: _size.width*0.06,
                    right: _size.width*0.06,
                  ),
                  padding: EdgeInsets.only(top: 10.0),
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
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        // color: Colors.blue,
                        height: 440.0,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // color: Colors.red,
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
                Visibility(
                  visible: pageIndex==0?true:false,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: (_size.height*0.25)+500.0+30.0, left: _size.width*0.15, right: _size.width*0.15),
                    child: NamedButtonComp(
                        text: "I have an account",
                        press: () {
                          // Navigator.pushNamedAndRemoveUntil(context, '/myApp', (route) => false);
                          Navigator.pop(context);
                        }
                    ),
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
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state){
        if(state is SignUpUserSuccess){
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
          if(state.authentication.success == true){
              print("Email: ${state.authentication.login.loginEmail}");
              print("ProfileId: ${state.authentication.login.userProfileId}");
              print("loginStates: ${state.authentication.login.loginStatus}");
              print("loginStatusString: ${state.authentication.login.loginStatusString}");
              print("SignUp Success");
            goBack();
            showAlertDialog(context, 'SignUp' ,"SignUp Success");
          }
          if(state.authentication.success == false){
              print("Success: ${state.authentication.success}");
              print("Exist: ${state.authentication.exist}");
              print("You Already SignIn ");
            goBack();
            showAlertDialog(context, 'SignUp', "You Already SignIn");
          }
        }
        if(state is SignUpUserFailed){
          LoaderFormState.hideLoader(context);
        }
        if(state is SignUpUserFailedException){
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
          showAlertDialog(context, 'Failed',state.errorObject);
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state){
          return buildSignUp(context);
        },
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

