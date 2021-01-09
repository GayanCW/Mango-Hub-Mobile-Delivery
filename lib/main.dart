import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangoHub/src/blocs/Authentication/authentication_bloc.dart';
import 'package:mangoHub/src/blocs/DeliveryFlow/delivery_flow_bloc.dart';
import 'package:mangoHub/src/blocs/GetNearbyCompanies/get_nearby_companies_bloc.dart';
import 'package:mangoHub/src/blocs/Orders/orders_history_bloc.dart';
import 'package:mangoHub/src/screens/Dashboard.dart';
import 'package:mangoHub/src/screens/Intro.dart';
import 'package:mangoHub/src/screens/LoginUser.dart';
import 'package:mangoHub/src/screens/ResetPassword.dart';
import 'package:mangoHub/src/screens/SignUpUser.dart';
import 'package:mangoHub/src/screens/UpdateUser.dart';
import 'package:mangoHub/src/shared/Colors.dart';

//My API key "AIzaSyAEpoBFxvVpzbg9pQgpKuWELNyH9pcKBf4"


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

    runApp(MultiBlocProvider(providers: [
        BlocProvider<GetNearbyCompaniesBloc>(create: (BuildContext context) => GetNearbyCompaniesBloc()),
        BlocProvider<DeliveryFlowBloc>(create: (BuildContext context) => DeliveryFlowBloc()),
        BlocProvider<OrdersHistoryBloc>(create: (BuildContext context) => OrdersHistoryBloc()),
        BlocProvider<AuthenticationBloc>(create: (BuildContext context) => AuthenticationBloc()),
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
        backgroundColor: mangoGrey,
        body: GestureDetector(
          // 'GestureDetector' use for hide soft input keyboard after clicking outside TextField/anywhere on screen
          child: Intro(),
          onTap: () {
            //  hide keyboard when clicking outside TextField/anywhere on screen
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/dashboard': (BuildContext context) => Dashboard(),
        '/loginUser': (BuildContext context) => LoginUser(),
        '/signUpUser': (BuildContext context) => SignUpUser(),
        '/resetPassword': (BuildContext context) => ResetPassword(),
      },
    );
  }
}


