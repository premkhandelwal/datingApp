import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/screens/auth/choose_sign_in_sign_up_page.dart';
import 'package:dating_app/screens/auth/logginInScreen.dart';
import 'package:dating_app/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: null,
      
      body: SafeArea(
        child: BlocBuilder<FirebaseauthBloc, FirebaseauthState>(
          builder: (context, state) {
        print(state);
        if (state is FirebaseauthInitial) {
          context.read<FirebaseauthBloc>().add(UserStateRequested());
        } else if (state is UserLoggedIn) {
          return HomePage();
        } else if (state is UserLoggedOut) {
          return ChooseSignInSignUpPage();
        }
        return LoggingIn();
          }),
      ));
  }
}
