import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/logic/data/user.dart';

abstract class BaseProfileDetailProvider {
  Future<void> addBasicInfo(CurrentUser user);
  Future<void> addGenderInfo(CurrentUser user);
  Future<void> addInterestInfo(CurrentUser user);
}

class ProfileDetailsProvider extends BaseProfileDetailProvider {
  CollectionReference collection =
      FirebaseFirestore.instance.collection("UserActivity");
  @override
  Future<void> addBasicInfo(CurrentUser user) async {
    try {
      await collection.doc(user.uid).collection("Details").add({
        "firstName": user.firstName,
        "lastName": user.lastName,
        "birthDate": user.birthDate
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addGenderInfo(CurrentUser user) async {
    try {
      await collection.doc(user.uid).collection("Details").add({
        "gender": user.gender!.index,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addInterestInfo(CurrentUser user) async {
    try {
      await collection.doc(user.uid).collection("Details").add({
        "interests": user.interests,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
