import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/logic/data/user.dart';

abstract class BaseProfileDetailProvider {
  Future<void> submitUserInfo(CurrentUser user);
}

class ProfileDetailsProvider extends BaseProfileDetailProvider {
  CollectionReference collection =
      FirebaseFirestore.instance.collection("UserActivity");

  @override
  Future<void> submitUserInfo(CurrentUser user) async {
    try {
      await collection.doc(user.uid).set({
        "name": user.name,
        "profession": user.profession,
        "birthDate": user.birthDate,
        "gender": user.gender!.index,
        "interests": user.interests,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
