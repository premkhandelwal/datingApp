import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/appliedFilters.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


abstract class BaseUserActivityProvider {
  Future<void> userLiked(String likedUserUID);
  Future<void> userDisliked(String likedUserUID);
  Future<CurrentUser?> userFindMatch(String matchUserUID);
  Future<void> updateLocationInfo();

  Future<List<CurrentUser>> fetchAllUsers();
  Future<List<CurrentUser>> fetchAllUsersWithAppliedFilters();
  Future<List<CurrentUser>> fetchMatchedUsers();
  Future<CurrentUser> fetchUserInfo(Map<String, num> locationCoordinates);
  Future<Map<String, num>> fetchLocationInfo();

  // Future<List<CurrentUser>> interestedInChanged(GENDER gender);
  // Future<List<CurrentUser>> distanceFilterChanged(List<CurrentUser> usersList,num thresholdDist);
  Future<List<CurrentUser>> filterChanged(
      num minAge, num maxAge, num thresholdDist, GENDER interestedIn);
  void clearAllFilters();
}

class UserActivityProvider extends BaseUserActivityProvider {
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("UserActivity");

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> updateLocationInfo() async {
    await collection
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .update({
      "locationCoordinates": SessionConstants.sessionUser.locationCoordinates
    });
  }

  @override
  Future<void> userDisliked(String dislikedUserUID) async {
    await collection
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .collection("InteractedUsers")
        .doc(dislikedUserUID)
        .set({"liked": false, "matched": false});
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

        await collection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .collection("InteractedUsers")
            .doc(matchUserUID)
            .set({"liked": true, "matched": true});

        await collection
            .doc(matchUserUID)
            .collection("InteractedUsers")
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .set({"liked": true, "matched": true});
      }
    });
    if (exist) {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await collection.doc(matchUserUID).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> dataMap = doc.data()!;
        CurrentUser user = CurrentUser.fromMap(dataMap);
        user.image = doc.data()!["profileImageUrl"] != null
            ? await urlToFile(dataMap["profileImageUrl"], user.uid)
            : null;
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
    await collection
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .collection("InteractedUsers")
        .doc(likedUserUID)
        .set({"liked": true, "matched": false});
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
      num _minAge = SessionConstants.sessionUser.age! - 3 <= 18
          ? 18
          : SessionConstants.sessionUser.age! - 3;
      num _maxAge = SessionConstants.sessionUser.age! + 3;
      SessionConstants.appliedFilters = AppliedFilters(
          minAge: _minAge,
          maxAge: _maxAge,
          thresholdDist: 5,
          interestedIn: SessionConstants.sessionUser.interestedin!);
      SessionConstants.defaultFilters = SessionConstants.appliedFilters;
      for (var i = 0; i < usersList.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> doc = await collection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .collection("InteractedUsers")
            .doc(usersList[i].uid)
            .get();
        if (doc.exists) {
          usersList.removeAt(i);
        }
      }
      usersList.removeWhere((element) {
        bool isDistanceGreaterthan5KM = false;

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
            (SessionConstants.sessionUser.interestedin != GENDER.both &&
                element.gender != SessionConstants.sessionUser.interestedin) ||
            (element.age != null &&
                (element.age! < _minAge || element.age! > _maxAge))) {
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
      usersList.removeWhere((user) =>
          user.uid ==
          SharedObjects.prefs?.getString(SessionConstants.sessionUid));
      return usersList;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<CurrentUser> fetchUserInfo(
      Map<String, num> locationCoordinates) async {
    try {
      CurrentUser user = CurrentUser();
      DocumentSnapshot<Map<String, dynamic>> doc = await collection
          .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
          .get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> dataMap = doc.data()!;
        user = CurrentUser.fromMap(dataMap);
        user.image = doc.data()!["profileImageUrl"] != null
            ? await urlToFile(doc.data()!["profileImageUrl"],
                SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            : null;
      }
      user.locationCoordinates = locationCoordinates;
      user.location = await coordinatestoLoc(locationCoordinates);

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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var first = placemarks.first;
    String location =
        "${first.subAdministrativeArea}, ${first.administrativeArea}";
    SessionConstants.sessionUser.location = location;

    return {"latitude": position.latitude, "longitude": position.longitude};
  }

  @override
  Future<List<CurrentUser>> filterChanged(
      num minAge, num maxAge, num thresholdDist, GENDER interestedIn) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
        querySnapshot.docs;

    List<CurrentUser> usersList =
        await CurrentUser.toCurrentList(listSnapShots);

    for (var i = 0; i < usersList.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> doc = await collection
          .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
          .collection("InteractedUsers")
          .doc(usersList[i].uid)
          .get();
      if (doc.exists) {
        usersList.removeAt(i);
      }
    }

    usersList.removeWhere((user) {
      if (user.uid ==
          SharedObjects.prefs?.getString(SessionConstants.sessionUid)) {
        return true;
      }
      if (user.age != null) {
        if (minAge > user.age! || user.age! > maxAge) {
          // user.agenotinFilters = true;
          return true;
        }
      }
      if (user.locationCoordinates != null) {
        num? distance = calculateDistance(user.locationCoordinates!);
        user.distance = distance;
        if (distance != null) {
          if (distance > thresholdDist && thresholdDist <= 80) {
            return true;
          }
        }
      }
      if (interestedIn != GENDER.both) {
        if (user.gender != interestedIn) {
          return true;
        }
      }
      return false;
    });
    return usersList;
  }

  /* @override
  Future<List<CurrentUser>> distanceFilterChanged(List<CurrentUser> usersList,num thresholdDist) async {
    
    if (thresholdDist >= 80) {
      return usersList;
    }
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
      
      return false;
    });
    return usersList;
  }
 */
  @override
  void clearAllFilters() {
    // SessionConstants.appliedFilters = SessionConstants.defaultFilters;
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
