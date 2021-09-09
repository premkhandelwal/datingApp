import 'dart:convert';

import 'package:dating_app/const/app_const.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String? uid;
  String? firstName;
  String? lastName;
  num? age;
  String? birthDate;
  GENDER? gender;
  INTERESTEDIN? interestedin;
  String? location;
  User? firebaseUser;
  List<String?>? interests;
  CurrentUser(
      {this.uid,
      this.firstName,
      this.lastName,
      this.age,
      this.birthDate,
      this.gender,
      this.interestedin,
      this.location,
      this.firebaseUser,
      this.interests
      });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'birthDate': birthDate,
      'gender': gender?.index,
      'interestedin': interestedin?.index,
      'location': location,
      'uid': uid,
      'interests':interests
    };
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    int gender = map['gender'];
    int interestedIn = map['interestedin'];
    return CurrentUser(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      age: map['age'],
      birthDate: map['birthDate'],
      gender: GENDER.values[gender],
      interestedin: INTERESTEDIN.values[interestedIn],
      location: map['location'],
      interests: map['interests']
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromMap(json.decode(source));
}
