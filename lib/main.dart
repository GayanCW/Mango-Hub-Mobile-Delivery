import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangoHub/src/blocs/EditUser/edit_user_bloc.dart';
import 'package:mangoHub/src/blocs/GetNearbyCompanies/get_nearby_companies_bloc.dart';
import 'package:mangoHub/src/blocs/Login/login_bloc.dart';
import 'package:mangoHub/src/blocs/SignUp/signUp_bloc.dart';
import 'package:mangoHub/src/googleMap/GoogleMapObj.dart';
import 'package:mangoHub/src/screens/EditUser.dart';
import 'package:mangoHub/src/screens/Intro.dart';
import 'package:mangoHub/src/screens/Login.dart';
import 'package:mangoHub/src/screens/Oder_Deatils.dart';
import 'package:mangoHub/src/screens/ResetPassword.dart';
import 'package:mangoHub/src/screens/SignUp.dart';
import 'package:mangoHub/src/services/CloudFirestore.dart';
import 'package:mangoHub/src/shared/Colors.dart';

//My API key "AIzaSyAEpoBFxvVpzbg9pQgpKuWELNyH9pcKBf4"

/*void main() {
  // runApp(MultiBlocProvider(providers: [
  //   BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
  //   BlocProvider<SignUpBloc>(create: (BuildContext context) => SignUpBloc()),
  //   BlocProvider<EditUserBloc>(create: (BuildContext context) => EditUserBloc()),
  // ], child: MyApp()));

  runApp(MultiBlocProvider(providers: [
    BlocProvider<EditUserBloc>(create: (BuildContext context) => EditUserBloc()),
    BlocProvider<GetNearbyCompaniesBloc>(create: (BuildContext context) => GetNearbyCompaniesBloc()),
   ], child: RunAfterLogin()));
  // runApp(RunAfterLogin());

}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    runApp(MultiBlocProvider(providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
        BlocProvider<SignUpBloc>(create: (BuildContext context) => SignUpBloc()),
        BlocProvider<EditUserBloc>(create: (BuildContext context) => EditUserBloc()),
        BlocProvider<GetNearbyCompaniesBloc>(create: (BuildContext context) => GetNearbyCompaniesBloc()),
      ], child: MyApp()));
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: GoogleFonts.openSans().fontFamily,
        primarySwatch: Colors.blue,
        backgroundColor: mangoBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: GestureDetector(
          // 'GestureDetector' use for hide soft input keyboard after clicking outside TextField/anywhere on screen
          child: Login(),
          onTap: () {
            //  hide keyboard when clicking outside TextField/anywhere on screen
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/myApp': (BuildContext context) => MyApp(),
        // '/dashboard': (BuildContext context) => OrderPage(),
        '/orderPage': (BuildContext context) => OderDeatils(),
        '/login': (BuildContext context) => Login(),
        '/signUp': (BuildContext context) => SignUp(),
        '/resetPassword': (BuildContext context) => ResetPassword(),
        '/editUser': (BuildContext context) => EditUser(),
      },
    );
  }
}

class RunAfterLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Tabs(pageTitle: 'MangoHub'),
      // home:FirebaseInitialize(),
    );
  }
}

