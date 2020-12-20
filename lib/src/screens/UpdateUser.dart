import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangoHub/src/blocs/Authentication/authentication_bloc.dart';
import 'package:mangoHub/src/components/AlertBox.dart';
import 'package:mangoHub/src/components/LoaderForm.dart';
import 'package:mangoHub/src/components/TextFormField.dart';
import 'package:mangoHub/src/models/APImodels/AuthenticationModel.dart';
import 'package:mangoHub/src/models/UImodels/District.dart';
import 'package:mangoHub/src/shared/Colors.dart';
import 'package:string_validator/string_validator.dart';


class UpdateUser extends StatefulWidget {
  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedDistrict;
  String selectedCity;
  List<String> districtsList = [];
  List<String> citiesList = [];

  File _image;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController addressLine1 = TextEditingController();
  final TextEditingController addressLine2 = TextEditingController();
  final TextEditingController zipCode = TextEditingController();

  Future<dynamic> _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("image:");
      print(_image);
    });
  }

  Future<LocalDistricts> loadDistricts() async {
    var response =
    jsonDecode(await rootBundle.loadString('assets/District.json'));
    LocalDistricts loadedDistricts = new LocalDistricts();
    loadedDistricts = LocalDistricts.fromJson(response);

    for (int i = 0; i < loadedDistricts.districts.length; i++) {
      districtsList.add(loadedDistricts.districts[i].district);
    }
    // districtsList.sort((A,Z)=>A.compareTo(Z));
    return loadedDistricts;
  }

  Future<LocalDistricts> loadCities(int districtIndex) async {
    var response =
    jsonDecode(await rootBundle.loadString('assets/District.json'));
    LocalDistricts loadedCities = new LocalDistricts();
    loadedCities = LocalDistricts.fromJson(response);

    for (int j = 0;
    j < loadedCities.districts[districtIndex].city.length;
    j++) {
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
    print("UpdateUser init state");
    print(_image);
  }

  void goBack() {
    setState(() {
      Navigator.pop(context);
    });
  }

  Widget buildUI(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: mangoGrey,
        appBar: AppBar(
          backgroundColor: mangoOrange,
          title: Text(
            "Edit profile".toUpperCase(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: mangoWhite),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.notifications_active,
                  size: 25.0,
                ),
                onPressed: () {}),
          ],
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 0,
        ),
        body: GestureDetector(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: [
                Container(
                  height: 250,
                  color: mangoOrange,
                ),
                Container(
                  margin: EdgeInsets.only(top: 150.0),
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 80,
                    left: 10.0,
                    right: 10.0,
                  ),
                  decoration: BoxDecoration(
                      color: mangoGrey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0))),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                color: mangoWhite,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: mangoWhite,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0,
                                  ),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "Edit your name",
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w300, color: mangoBlackText,),
                                    ),
                                  ),
                                ),
                                SingleEditTextFormField(
                                  title: "First name",
                                  inputText: firstName,
                                  textInputType: TextInputType.name,
                                  hintText: "Gayan",
                                  validatorFunction: (value) {
                                    if (value.isEmpty) {
                                      return "Required";
                                    }
                                    if (isAlpha(value) == false) {
                                      return "invalid name type";
                                    }
                                  },
                                ),
                                SingleEditTextFormField(
                                  title: "Last name",
                                  inputText: lastName,
                                  textInputType: TextInputType.name,
                                  hintText: "Weerasinghe",
                                  validatorFunction: (value) {
                                    if (value.isEmpty) {
                                      return "Required";
                                    }
                                    if (isAlpha(value) == false) {
                                      return "invalid name type";
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            margin: EdgeInsets.only(
                              top: 5.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                color: mangoWhite,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: mangoWhite,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0,
                                  ),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "Edit your Address",
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w300, color: mangoBlackText,),
                                    ),
                                  ),
                                ),
                                SingleEditTextFormField(
                                  title: "Address line1",
                                  inputText: addressLine1,
                                  hintText: "Ex:",
                                  validatorFunction: (value) {
                                    if (value.isEmpty) {
                                      return "Required";
                                    }
                                  },
                                ),
                                SingleEditTextFormField(
                                    title: "Address line 2",
                                    inputText: addressLine2,
                                    hintText: "Ex:",
                                    validatorFunction: null),
                                Container(
                                  // color: Colors.green,
                                  margin: EdgeInsets.only(top: 2.0),
                                  height: 100.0,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "District",
                                        style: TextStyle(fontSize: 18.0, color: mangoText),
                                      ),
                                      DropdownSearch<String>(
                                        validator: (v) =>
                                        v == null ? "Required" : null,
                                        hint: "Select a district",
                                        mode: Mode.DIALOG,
                                        selectedItem: selectedDistrict,
                                        showSelectedItem: true,
                                        items: districtsList,
                                        showClearButton: true,
                                        showSearchBox: true,
                                        onChanged: (value) {
                                          selectedDistrict = value;
                                          selectedCity = null;
                                          citiesList.clear();
                                          loadCities(
                                              districtsList.indexOf(value));
                                        },
                                        popupBackgroundColor: mangoWhite,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100.0,
                                  margin: EdgeInsets.only(top: 2.0),
                                  // color: Colors.green,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "City",
                                        style: TextStyle(fontSize: 18.0,color: mangoText),
                                      ),
                                      DropdownSearch<String>(
                                        validator: (v) =>
                                        v == null ? "Required" : null,
                                        hint: "Select a city",
                                        mode: Mode.DIALOG,
                                        selectedItem: selectedCity,
                                        showSelectedItem: true,
                                        items: citiesList,
                                        showClearButton: true,
                                        showSearchBox: true,
                                        onChanged: (value) {
                                          selectedCity = value;
                                        },
                                        popupBackgroundColor: mangoWhite,
                                      ),
                                    ],
                                  ),
                                ),
                                SingleEditTextFormField(
                                  title: "Zip code",
                                  inputText: zipCode,
                                  textInputType: TextInputType.number,
                                  hintText: "8080",
                                  validatorFunction: (value) {
                                    if (value.isEmpty) {
                                      return "Required";
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 40.0,
                                  width: 120.0,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22.0),
                                    ),
                                    color: mangoOrange,
                                    splashColor: Colors.orange,
                                    disabledColor: mangoOrange,
                                    child: Center(
                                      child: Text(
                                        "Cancle",
                                        style: TextStyle(
                                            color: mangoWhite,
                                            fontSize: _size.height * 0.025),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _formKey.currentState
                                            .reset(); // reset validation
                                        TextEditingController().clear();
                                        FocusScope.of(context).requestFocus(
                                            FocusNode()); //  hide keyboard from setState & page routing
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  height: 40.0,
                                  width: 120.0,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22.0),
                                    ),
                                    color: mangoBlue,
                                    splashColor: Colors.blue,
                                    disabledColor: mangoOrange,
                                    child: Center(
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            color: mangoWhite,
                                            fontSize: _size.height * 0.025),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (!_formKey.currentState.validate()) {
                                        return;
                                      } else {
                                        FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
                                        LoaderFormState.showLoader(context, "Please wait...");
                                          BlocProvider.of<AuthenticationBloc>(context).add(
                                            GetUpdateUserDetails(
                                              authentication: Authentication(
                                                login: Login(
                                                  userProfileId: "5f8156eb91c1a0064b74e17a" // SecureStorage............................
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
                                                  userStatus: true, //need to change this to false.. aniwa hodeeee................................
                                                )
                                              ),
                                          )
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 200.0, width: 200.0,
                    margin: EdgeInsets.only(top: 5.0),
                    // color: Colors.green,
                    child: Stack(
                      children: [
                        Container(
                          /*margin: EdgeInsets.only(top: 20, bottom: 20),
                            width: 200.0,
                            height: 200.0,*/
                            decoration: BoxDecoration(
                                color: mangoOrange,
                                image: DecorationImage(
                                    image: (_image == null)
                                        ? AssetImage("assets/images/delivery-man2.jpg")
                                        : FileImage(_image),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                                boxShadow: [
                                  BoxShadow(blurRadius: 5.0, color: Colors.grey)
                                ])),
                        /*CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 100,
                          backgroundImage: (_image == null)
                              ? AssetImage("assets/images/delivery-man2.jpg")
                              : FileImage(_image),
                        ),*/
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                backgroundColor: mangoOrange,
                                child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      onPressed: _getImage,
                                    )),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(
                FocusNode()); //  hide keyboard when clicking outside TextField/anywhere on screen
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("UpdateUser build state");
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
            print("first name: ${state.authentication.user.userFirstName}");
            print("ProfileId: ${state.authentication.login.userProfileId}");
            print("district: ${state.authentication.user.userAddress.district}");
            print("city: ${state.authentication.user.userAddress.city}");
            print("EditUser Success");
              showAlertDialog(context, 'Success','Registered Successfully');
        }
        if (state is UpdateUserFailed) {
          LoaderFormState.hideLoader(context);
        }
        if (state is UpdateUserFailedException) {
          FocusScope.of(context).requestFocus(FocusNode()); //  hide keyboard from setState & page routing
          LoaderFormState.hideLoader(context);
          showAlertDialog(context, 'Failed',state.errorObject);

        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return buildUI(context);
        },
      ),
    );
  }
}
