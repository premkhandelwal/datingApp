import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class BaseProfileDetailProvider {
  Future<void> updateUserInfo(CurrentUser user);
  Future<void> submitUserInfo(CurrentUser user);
  Future<void> uploadImages(List<File> images);
}

class ProfileDetailsProvider extends BaseProfileDetailProvider {
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("UserActivity");

  CollectionReference<Map<String, dynamic>> dataLessCollection =
      FirebaseFirestore.instance.collection("DataLessUsers");

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> updateUserInfo(CurrentUser user) async {
    Reference ref = storage.ref().child(
        "userImages/${SharedObjects.prefs?.getString(SessionConstants.sessionUid)}/profileImage");
    if (user.image != null) {
      UploadTask uploadTask = ref.putFile(user.image!);
      await uploadTask.whenComplete(() async {
        user.imageDownloadUrl = await ref.getDownloadURL();
        await collection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .update({
          "name": user.name,
          "profession": user.profession,
          "bio": user.bio,
          "interests": user.interests,
          "interestedIn": user.interestedin?.index,
          "profileImageUrl":
              user.imageDownloadUrl != null ? user.imageDownloadUrl : null,
          "locationCoordinates": user.locationCoordinates
        });
      });
    }
  }

  @override
  Future<void> submitUserInfo(CurrentUser user) async {
    try {
      Reference ref = storage.ref().child(
          "userImages/${SharedObjects.prefs?.getString(SessionConstants.sessionUid)}/profileImage");
      UploadTask uploadTask;
      if (user.image != null) {
        uploadTask = ref.putFile(user.image!);
        await uploadTask.whenComplete(() async {
          user.imageDownloadUrl = await ref.getDownloadURL();
          print(SharedObjects.prefs?.getString(SessionConstants.sessionUid));
          await collection
              .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
              .set({
            "name": user.name,
            "uid": FirebaseAuth.instance.currentUser!.uid,
            "status": "Online",
            "age": user.age,
            "profession": user.profession,
            "birthDate": user.birthDate,
            "gender": user.gender == GENDER.male
                ? "Male"
                : user.gender == GENDER.female
                    ? "Female"
                    : "Other",
            "interests": user.interests,
            "interestedIn": user.interestedin == GENDER.male
                ? "Male"
                : user.interestedin == GENDER.female
                    ? "Female"
                    : "Other",
            "profileImageUrl":
                user.imageDownloadUrl != null ? user.imageDownloadUrl : null,
            "lastLogin": DateTime.now()
          });
          await dataLessCollection
              .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
              .delete();
        });
      } else {
        await collection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .set({
          "name": user.name,
          "age": user.age,
          "profession": user.profession,
          "birthDate": user.birthDate,
          "gender": user.gender == GENDER.male
              ? "Male"
              : user.gender == GENDER.female
                  ? "Female"
                  : "Other",
          "interestedIn": user.interestedin == GENDER.male
              ? "Male"
              : user.interestedin == GENDER.female
                  ? "Female"
                  : "Other",
          "interests": user.interests,
          "profileImageUrl": null,
          "lastLogin": DateTime.now()
        });
        await dataLessCollection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .delete();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> uploadImages(List<File> images) async {
    try {
      if (images.isEmpty) return null;
      List<String> _downloadUrls = [];
      String? uid = SharedObjects.prefs?.getString(SessionConstants.sessionUid);
      for (var i = 0; i < images.length; i++) {
        Reference ref = storage.ref("userImages/$uid").child(
            (SessionConstants.sessionUser.images != null
                    ? SessionConstants.sessionUser.images!.length + i
                    : i + 1)
                .toString());
        final UploadTask uploadTask = ref.putFile(images[i]);
        // final TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() async {
          final url = await ref.getDownloadURL();

          _downloadUrls.add(url);
        });
      }

      if (SessionConstants.sessionUser.images == null) {
        SessionConstants.sessionUser.images = [];
      }
      SessionConstants.sessionUser.images =
          SessionConstants.sessionUser.images! + images;

      await collection
          .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
          .update({"imagesUrl": FieldValue.arrayUnion(_downloadUrls)});
    } catch (e) {
      throw Exception(e);
    }
  }
}
