import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class BaseProfileDetailProvider {
  Future<void> updateUserInfo(CurrentUser user);
  Future<void> submitUserInfo(CurrentUser user);
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
          await collection
              .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
              .set({
            "name": user.name,
            "age": user.age,
            "profession": user.profession,
            "birthDate": user.birthDate,
            "gender": user.gender?.index,
            "interests": user.interests,
            "interestedIn": user.interestedin?.index,
            "profileImageUrl":
                user.imageDownloadUrl != null ? user.imageDownloadUrl : null
          });
          await dataLessCollection
              .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
              .delete();
        }).catchError((onError) {
          print(onError);
        });
      } else {
        await collection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .set({
          "name": user.name,
          "age": user.age,
          "profession": user.profession,
          "birthDate": user.birthDate,
          "gender": user.gender?.index,
          "interests": user.interests,
          "interestedIn": user.interestedin?.index,
          "profileImageUrl": null
        });
        await dataLessCollection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .delete();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
