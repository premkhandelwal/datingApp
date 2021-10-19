import 'dart:convert';
import 'dart:io';
import 'package:dating_app/const/app_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String? uid;
  String? name;
  String? profession;
  String? bio;
  String? location;
  num? age;
  num? distance;
  DateTime? birthDate;
  GENDER? gender;
  GENDER? interestedin;
  File? image;
  String? imageDownloadUrl;
  User? firebaseUser;
  List<String>? interests;
  Map<String, num>? locationCoordinates; //{Latitude:0,Longitude:0}
  List<File>? images = [];
  CurrentUser(
      {this.uid,
      this.name,
      this.profession,
      this.bio,
      this.age,
      this.distance,
      this.image,
      this.birthDate,
      this.gender,
      this.interestedin,
      this.location,
      this.firebaseUser,
      this.imageDownloadUrl,
      this.locationCoordinates,
      this.interests,
      this.images   
      });

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    // int interestedIn = map['interestedin'];
    return CurrentUser(
      uid: map['uid'] != null ? map['uid'] : null,
      name: map['name'] != null ? map['name'] : null,
      profession: map['profession'] != null ? map['profession'] : null,
      bio: map['bio'] != null ? map['bio'] : null,
      age: map['age'] != null ? map['age'] : null,
      birthDate: map['birthDate'] != null ? map['birthDate'].toDate() : null,
      gender: map["gender"] == "Male"
          ? GENDER.male
          : map["gender"] == "Female"
              ? GENDER.female
              : GENDER.other,
      interestedin: map["interestedIn"] != null
          ? map["interestedIn"] == "Male"
              ? GENDER.male
              : map["interestedIn"] == "Female"
                  ? GENDER.female
                  : GENDER.other
          : GENDER.NotSelected,
      // interestedin: INTERESTEDIN.values[interestedIn],
      location: map['location'] ?? map['location'],
      imageDownloadUrl:
          map['profileImageUrl'] != null ? map['profileImageUrl'] : null,
      interests:
          map['interests'] != null ? List<String>.from(map['interests']) : [],
      locationCoordinates: map['locationCoordinates'] != null
          ? Map<String, num>.from(map['locationCoordinates'])
          : {},
    );
  }

  static Future<List<CurrentUser>> toCurrentList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) async {
    List<CurrentUser> usersList = [];
    for (var snapshot in snapshots) {
      usersList.add(CurrentUser.fromMap(snapshot.data()));

      usersList[usersList.length - 1].uid = snapshot.id;
      
      if (snapshot.data()["profileImageUrl"] != null) {
        usersList[usersList.length - 1].image =
            await urlToFile(snapshot.data()["profileImageUrl"], snapshot.id);
      }
      
      if (snapshot.data()["locationCoordinates"] != null) {
        Map<String, num> locationCoordainates =
            Map<String, num>.from(snapshot.data()["locationCoordinates"]);
        usersList[usersList.length - 1].location =
            await coordinatestoLoc(locationCoordainates);
      }
    }
    return usersList;
  }

  factory CurrentUser.fromJson(String source) =>
      CurrentUser.fromMap(json.decode(source));
}
