import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionConstants {
  static const sessionUid = "sessionUid";
  static const sessionUsername = 'sessionUsername';
  static const sessionSignedInWith = "sessionSignedInWith"; //[phone Number, email]
}

const Color AppColor = Color(0xffE94057);
enum GENDER { NotSelected, male, female, other }
enum INTERESTEDIN { Male, Female, Both }

void changePageTo({required BuildContext context, required Widget widget}) {
  context.read<FirebaseauthBloc>().add(UserStateNone());
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => widget));
}

void changePageWithoutBack(
    {required BuildContext context, required Widget widget}) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (ctx) => widget), (route) => false);
}
