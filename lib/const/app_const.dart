import 'package:dating_app/logic/bloc/firebaseAuth/firebaseauth_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionConstants {
  static List<CurrentUser> allUsers = [];
  static const sessionUid = "sessionUid";
  static const sessionUsername = 'sessionUsername';
  static const sessionSignedInWith = "sessionSignedInWith";
  static const sessionAllFetchedUsers =
      "sessionAllFetchedUsers"; //[phone Number, email]
}

const Color AppColor = Color(0xffE94057);
enum GENDER { NotSelected, male, female, other }
enum INTERESTEDIN { Male, Female, Both }

int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

void changePageTo({required BuildContext context, required Widget widget}) {
  context.read<FirebaseauthBloc>().add(UserStateNone());
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => widget));
}

void changePageWithoutBack(
    {required BuildContext context, required Widget widget}) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (ctx) => widget), (route) => false);
}
