import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating App',
      theme: ThemeData(
        accentColor: AppColor.withOpacity(0.1),
        primaryColor: AppColor,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyText1: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              fontFamily: 'Modernist'),
          bodyText2: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontFamily: 'Modernist'),
          subtitle1: TextStyle(fontSize: 14, fontFamily: 'Modernist'),
          subtitle2: TextStyle(fontSize: 18, fontFamily: 'Modernist'),
        ),
      ),
      // home: DiscoverScreen(),
      home: ChooseSignInSignUpPage(),
    );
  }
}
