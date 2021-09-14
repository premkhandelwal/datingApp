import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String? uid;
  String? name;
  String? profession;
  String? bio;
  String? location;
  num? age;
  DateTime? birthDate;
  GENDER? gender;
  INTERESTEDIN? interestedin;
  File? image;
  String? imageDownloadUrl;
  User? firebaseUser;
  List<String>? interests;
  CurrentUser(
      {this.uid,
      this.name,
      this.profession,
      this.bio,
      this.age,
      this.image,
      this.birthDate,
      this.gender,
      this.interestedin,
      this.location,
      this.firebaseUser,
      this.imageDownloadUrl,
      this.interests});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profession': profession,
      'bio': bio,
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
      profession: map['profession'] != null ? map['profession'] : null,
      bio: map['bio'] != null ? map['bio'] : null,
      age: map['age'] != null ? map['age'] : null,
      birthDate: map['birthDate'] != null ? map['birthDate'].toDate() : null,
      gender: gender != null ? GENDER.values[gender] : GENDER.NotSelected,
      // interestedin: INTERESTEDIN.values[interestedIn],
      location: map['location'] ?? map['location'],
      imageDownloadUrl:
          map['profileImageUrl'] != null ? map['profileImageUrl'] : null,
      interests:
          map['interests'] != null ? List<String>.from(map['interests']) : [],
    );
  }

  static Future<List<CurrentUser>> toCurrentList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) async{
    List<CurrentUser> users = [];
    for (var snapshot in snapshots) {
      
      users.add(CurrentUser.fromMap(snapshot.data()));
      users[users.length - 1].uid = snapshot.id;
      if(snapshot.data()["profileImageUrl"] != null){
       users[users.length - 1].image = await urlToFile(snapshot.data()["profileImageUrl"],snapshot.id);
      }
    }
    return users;
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromMap(json.decode(source));
}
