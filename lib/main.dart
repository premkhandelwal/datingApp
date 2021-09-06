import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseauth_bloc.dart';
import 'package:dating_app/logic/repositories/firebaseAuthRepo.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    firebaseAuthRepository: FirebaseAuthRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseAuthRepository firebaseAuthRepository;
  const MyApp({
    Key? key,
    required this.firebaseAuthRepository,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FirebaseauthBloc(firebaseAuthRepo: firebaseAuthRepository),
        )
      ],
      child: MaterialApp(
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
        home: ChooseSignInSignUpPage(),
      ),
      // home: DiscoverScreen(),
      
    );
  }
}
