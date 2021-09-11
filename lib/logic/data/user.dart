import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String? uid;
  String? name;
  String? profession;
  num? age;
  DateTime? birthDate;
  GENDER? gender;
  INTERESTEDIN? interestedin;
  String? location;
  User? firebaseUser;
  List<String?>? interests;
  CurrentUser(
      {this.uid,
      this.name,
      this.profession,
      this.age,
      this.birthDate,
      this.gender,
      this.interestedin,
      this.location,
      this.firebaseUser,
      this.interests});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profession': profession,
      'age': age,
      'birthDate': birthDate,
      'gender': gender?.index,
      'interestedin': interestedin?.index,
      'location': location,
      'uid': uid,
      'interests': interests
    };
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    int? gender = map['gender'] ?? null;
    // int interestedIn = map['interestedin'];
    return CurrentUser(
        uid: map['uid'] != null ? map['uid'] : null,
        name: map['name'] != null ? map['name'] : null,
        profession: map['profession'] ?? null,
        // age: map['age'],
        birthDate: map['birthDate'] != null ? map['birthDate'].toDate() : null,
        gender: gender != null ? GENDER.values[gender] : GENDER.NotSelected,
        // interestedin: INTERESTEDIN.values[interestedIn],
        location: map['location'] ?? map['location'],
        interests: map['interests'] != null
            ? List<String>.from(map['interests'])
            : []);
  }

  static List<CurrentUser> toCurrentList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) {
    List<CurrentUser> users = [];
    for (var snapshot in snapshots) {
      users.add(CurrentUser.fromMap(snapshot.data()));
    }
    return users;
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromMap(json.decode(source));
}
