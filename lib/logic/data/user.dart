import 'dart:convert';

import 'package:dating_app/const/app_const.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String? name;
  num? age;
  String? birthDate;
  GENDER? gender;
  INTERESTEDIN? interestedin;
  String? location;
  User? firebaseUser;
  CurrentUser({
    this.name,
    this.age,
    this.birthDate,
    this.gender,
    this.interestedin,
    this.location,
    this.firebaseUser
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'birthDate': birthDate,
      'gender': gender?.index,
      'interestedin': interestedin?.index,
      'location': location,
    };
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    int gender = map['gender'];
    int interestedIn = map['interestedin'];
    return CurrentUser(
      name: map['name'],
      age: map['age'],
      birthDate: map['birthDate'],
      gender: GENDER.values[gender],
      interestedin: INTERESTEDIN.values[interestedIn],
      location: map['location'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CurrentUser(name: $name, age: $age, birthDate: $birthDate, gender: $gender, interestedin: $interestedin, location: $location)';
  }
}
