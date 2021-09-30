import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class BaseUserActivityProvider {
  Future<void> userLiked(String likedUserUID);
  Future<void> userDisliked(String likedUserUID);
  Future<CurrentUser?> userFindMatch(String matchUserUID);
  Future<void> updateLocationInfo(Map<String, num> locationCoordinates);

  Future<List<CurrentUser>> fetchAllUsers();
  Future<List<CurrentUser>> fetchAllUsersWithAppliedFilters();
  Future<List<CurrentUser>> fetchMatchedUsers();
  Future<CurrentUser> fetchUserInfo();
  Future<Map<String, num>> fetchLocationInfo();

  Future<List<CurrentUser>> interestedInChanged(GENDER gender);
  Future<List<CurrentUser>> distanceFilterChanged(num thresholdDist);
  Future<List<CurrentUser>> ageFilterChanged(num minAge, num maxAge);
  void clearAllFilters();
}

class UserActivityProvider extends BaseUserActivityProvider {
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("UserActivity");

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> updateLocationInfo(Map<String, num> locationCoordinates) async {
    SessionConstants.sessionUser.locationCoordinates = locationCoordinates;
    await collection
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .update({"locationCoordinates": locationCoordinates});
  }

  @override
  Future<void> userDisliked(String dislikedUserUID) async {
    await collection
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .collection("DislikedUsers")
        .doc(dislikedUserUID)
        .set({dislikedUserUID: DateTime.now()});
  }

  @override
  Future<CurrentUser?> userFindMatch(String matchUserUID) async {
    bool exist = false;
    await collection
        .doc(matchUserUID)
        .collection("LikedUsers")
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .get()
        .then((doc) async {
      exist = doc.exists;
      if (exist) {
        String? selfUid =
            SharedObjects.prefs?.getString(SessionConstants.sessionUid);
        await collection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .collection("MatchedUsers")
            .doc(matchUserUID)
            .set({matchUserUID: DateTime.now()});

        await collection
            .doc(matchUserUID)
            .collection("MatchedUsers")
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .set({selfUid!: DateTime.now()});
      }
    });
    if (exist) {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await collection.doc(matchUserUID).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> dataMap = doc.data()!;
        CurrentUser user = CurrentUser.fromMap(dataMap);
        user.image = await urlToFile(dataMap["profileImageUrl"], user.uid);
        return user;
      }
    }
    return null;
  }

  @override
  Future<void> userLiked(String likedUserUID) async {
    await collection
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .collection("LikedUsers")
        .doc(likedUserUID)
        .set({likedUserUID: DateTime.now()});
  }

  @override
  Future<List<CurrentUser>> fetchAllUsersWithAppliedFilters() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
          querySnapshot.docs;

      List<CurrentUser> usersList =
          await CurrentUser.toCurrentList(listSnapShots);

      usersList.removeWhere((element) {
        bool isDistanceGreaterthan5KM = false;
        SessionConstants.appliedFilters = {
          if (SessionConstants.sessionUser.interestedin != null)
            GenderFilterChangedEvent(
                interestedIn: SessionConstants.sessionUser.interestedin!): true,
          DistanceFilterChangedEvent(thresholdDist: 5): true
        };
        if (element.locationCoordinates != null) {
          double? distanceInKilometers =
              calculateDistance(element.locationCoordinates!);
          element.distance = distanceInKilometers;
          if (distanceInKilometers != null) {
            isDistanceGreaterthan5KM = distanceInKilometers > 5;
          }
        }
        if ((element.uid ==
                SharedObjects.prefs?.getString(SessionConstants.sessionUid)) ||
            isDistanceGreaterthan5KM ||
            element.gender != SessionConstants.sessionUser.interestedin) {
          return true;
        }

        return false;
      });
      // SessionConstants.allUsers = usersList;

      return usersList;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<CurrentUser>> fetchMatchedUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
          .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
          .collection("MatchedUsers")
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
          querySnapshot.docs;
      List<CurrentUser> usersList =
          await CurrentUser.toCurrentList(listSnapShots);
      return usersList;
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
        user.image = await urlToFile(doc.data()!["profileImageUrl"],
            SharedObjects.prefs?.getString(SessionConstants.sessionUid));
      }
      SessionConstants.sessionUser = user;
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, num>> fetchLocationInfo() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("position");
    print(position);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var first = placemarks.first;
    String location =
        "${first.subAdministrativeArea}, ${first.administrativeArea}";
    SessionConstants.sessionUser.location = location;

    return {"latitude": position.latitude, "longitude": position.longitude};
  }

  @override
  Future<List<CurrentUser>> ageFilterChanged(num minAge, num maxAge) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
        querySnapshot.docs;

    List<CurrentUser> usersList =
        await CurrentUser.toCurrentList(listSnapShots);
    usersList.removeWhere((user) {
      if (user.age != null) {
        if (minAge > user.age! || user.age! > maxAge) {
          // user.agenotinFilters = true;
          return true;
        }
      }
      return false;
    });
    return usersList;
  }

  @override
  Future<List<CurrentUser>> distanceFilterChanged(num thresholdDist) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
        querySnapshot.docs;

    List<CurrentUser> usersList =
        await CurrentUser.toCurrentList(listSnapShots);
    usersList.removeWhere((user) {
      if (user.locationCoordinates != null) {
        num? distance = calculateDistance(user.locationCoordinates!);

        if (distance != null) {
          if (distance > thresholdDist) {
            return true;
          }
        }
      }
      return false;
    });
    return usersList;
  }

  @override
  Future<List<CurrentUser>> interestedInChanged(GENDER interestedIn) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
        querySnapshot.docs;

    List<CurrentUser> usersList =
        await CurrentUser.toCurrentList(listSnapShots);
    usersList.removeWhere((user) {
      if (interestedIn != GENDER.both) {
        if (user.gender != interestedIn) {
          return true;
        }
      }
      return false;
    });
    return usersList;
  }

  @override
  void clearAllFilters() {
    /* SessionConstants.allUsers.forEach((user) {
      user.gendernotinFilters = null;
      user.agenotinFilters = null;
      user.distancenotinFilters = null;
    }); */
  }

  @override
  Future<List<CurrentUser>> fetchAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
          querySnapshot.docs;

      List<CurrentUser> usersList =
          await CurrentUser.toCurrentList(listSnapShots);
      return usersList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
