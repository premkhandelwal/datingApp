import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/logic/bloc/profileDetails/profiledetails_bloc.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/repositories/firebaseAuthRepo.dart';
import 'package:dating_app/logic/repositories/profileDetailsRepo.dart';
import 'package:dating_app/logic/repositories/userActivityRepo.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    firebaseAuthRepository: FirebaseAuthRepository(),
    userActivityRepository: UserActivityRepository(),
    profileDetailsRepository: ProfileDetailsRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseAuthRepository firebaseAuthRepository;
  final UserActivityRepository userActivityRepository;
  final ProfileDetailsRepository profileDetailsRepository;
  const MyApp({
    Key? key,
    required this.firebaseAuthRepository,
    required this.userActivityRepository,
    required this.profileDetailsRepository,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FirebaseauthBloc(firebaseAuthRepo: firebaseAuthRepository),
        ),
        BlocProvider(
          create: (context) =>
              UseractivityBloc(userActivityRepository: userActivityRepository),
        ),
        BlocProvider(
          create: (context) => ProfiledetailsBloc(
            profileDetailsRepository: profileDetailsRepository,
          ),
        ),
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
        // home: ChooseSignInSignUpPage(),
        home: HomePage(),
      ),
    );
  }
}
