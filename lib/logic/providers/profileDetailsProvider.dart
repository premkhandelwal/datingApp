import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class BaseProfileDetailProvider {
  Future<void> submitUserInfo(CurrentUser user);
  Future<CurrentUser> fetchUserInfo();
  Future<String?> fetchLocationInfo();
}

class ProfileDetailsProvider extends BaseProfileDetailProvider {
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("UserActivity");

  @override
  Future<void> submitUserInfo(CurrentUser user) async {
    try {
      await collection
          .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
          .set({
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

  @override
  Future<CurrentUser> fetchUserInfo() async {
    try {
      CurrentUser user = CurrentUser();
      DocumentSnapshot<Map<String, dynamic>> doc = await collection
          .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
          .get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> dataMap = doc.data()!;
        user = CurrentUser.fromMap(dataMap);
      }
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String?> fetchLocationInfo() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("position");
    print(position);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var first = placemarks.first;
    return "${first.subAdministrativeArea}, ${first.administrativeArea}";
  }
}
