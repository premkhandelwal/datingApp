import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseUserActivityProvider {
  Future<void> userLiked(String likedUserUID);
  Future<void> userDisliked(String likedUserUID);
  Future<CurrentUser?> userFindMatch(String matchUserUID);
  Future<void> updateLocationInfo();
  Stream<List<CurrentUser>> fetchAllUsers();
  Future<List<CurrentUser>> fetchAllUsersWithAppliedFilters();
  Future<List<CurrentUser>> fetchMatchedUsers();
  Future<CurrentUser> fetchUserInfo(Map<String, num> locationCoordinates);
  Future<Map<String, num>> fetchLocationInfo();
  Future<List<CurrentUser>> filterChanged(
      num minAge, num maxAge, num thresholdDist, GENDER interestedIn);
}

class UserActivityProvider extends BaseUserActivityProvider {
  CollectionReference collection =
      FirebaseFirestore.instance.collection("UserActivity");

  @override
  Future<void> userDisliked(String userUID, String dislikedUserUID) async {
    await collection
        .doc(userUID)
        .collection("DislikedUsers")
        .doc(dislikedUserUID)
        .set({dislikedUserUID: DateTime.now()});
  }

  @override
  Future<bool> userFindMatch(String matchUserUID, String selfUID) async {
    bool exist = false;
    print(selfUID);
    await collection
        .doc(matchUserUID)
        .collection("LikedUsers")
        .doc(selfUID)
        .get()
        .then((doc) {
      exist = doc.exists;
    });
    return exist;
  }

  @override
  Future<void> userLiked(String userUID, String likedUserUID) async {
    await collection
        .doc(userUID)
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
        String? uid =
            SharedObjects.prefs?.getString(SessionConstants.sessionUid);
        user = CurrentUser.fromMap(dataMap);
        user.image = doc.data()!["profileImageUrl"] != null
            ? await urlToFile(doc.data()!["profileImageUrl"], uid)
            : null;
        if (doc.data()!["imagesUrl"] != null) {
          List imageUrls = doc.data()!["imagesUrl"];
          print(imageUrls);
          for (var i = 0; i < imageUrls.length; i++) {
            if (user.images == null) {
              user.images = [];
            }
            user.images!.add(
                await urlToFile(imageUrls[i], "${uid! + (i + 1).toString()}"));
          }
        }
      }
      user.locationCoordinates = locationCoordinates;
      user.location = await coordinatestoLoc(locationCoordinates);
      user.uid = SharedObjects.prefs?.getString(SessionConstants.sessionUid);

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

  @override
  Stream<List<CurrentUser>> fetchAllUsers() {
    try {
      // QuerySnapshot<Map<String, dynamic>> querySnapshot =
      return collection.snapshots().transform(
            StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
                List<CurrentUser>>.fromHandlers(
              handleData: (QuerySnapshot<Map<String, dynamic>> querySnapshot,
                      EventSink<List<CurrentUser>> sink) =>
                  mapQueryToConversation(querySnapshot, sink),
            ),
          );
      /* List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
          querySnapshot.docs;

      List<CurrentUser> usersList =
          await CurrentUser.toCurrentList(listSnapShots);
      return usersList;
           */
    } catch (e) {
      throw Exception(e);
    }
  }

  void mapQueryToConversation(QuerySnapshot<Map<String, dynamic>> querySnapshot,
      EventSink<List<CurrentUser>> sink) async {
    List<CurrentUser> usersList =
        await CurrentUser.toCurrentList(querySnapshot.docs);
    sink.add(usersList);
  }
}
