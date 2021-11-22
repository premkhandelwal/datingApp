import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/applied_filters.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class BaseUserActivityProvider {
  Future<void> userLiked(String likedUserUID);
  Future<void> userDisliked(String dislikedUserUID);
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
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("UserActivity");

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> updateLocationInfo() async {
    //Updates the location of the user in the Firestore Database
    await collection
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .update({
      "locationCoordinates": SessionConstants.sessionUser.locationCoordinates
    });
  }

  @override
  Future<void> userLiked(String likedUserUID) async {
    // Is called whenever user likes some other user
    /* InteractedUsers is a sub-collection in Firestore Database, where we have two variables "liked" and "matched".
      "liked" will be false, if user has disliked someone, otherwise will be true
      "matched" will be true, if both the users have liked each other*/
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
  Future<void> userDisliked(String dislikedUserUID) async {
    // Is called whenever user dislikes some other user
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
        .collection(
            "LikedUsers") // First check in the collection of the matched User, whether the SessionUser's uid is present or not
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .get()
        .then((doc) async {
      exist = doc
          .exists; // User is matched if exist is true, because both the users' have liked each other
      if (exist) {
        String? selfUid =
            SharedObjects.prefs?.getString(SessionConstants.sessionUid);

        // In the SessionUser's collection of the SessionUser, set the key as matchedUser's uid and value as DateTime.now()
        await collection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .collection("MatchedUsers")
            .doc(matchUserUID)
            .set({matchUserUID: DateTime.now()});

        // In the matchedUsers collection of the SessionUser, set the key as SessionUser's uid and value as DateTime.now()
        await collection
            .doc(matchUserUID)
            .collection("MatchedUsers")
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .set({selfUid!: DateTime.now()});

        // In the InteractedUsrs collection of the SessionUser and MatchedUser, set "matched" and "liked" as true
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
    // At this point, we have only UID of the matchedUser. Below part of the code fetches all the information of the matched user and return the same
    if (exist) {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await collection.doc(matchUserUID).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> dataMap = doc.data()!;
        CurrentUser user = CurrentUser.fromMap(dataMap);
        user.image = doc.data()!["profileImageUrl"] != null
            ? await urlToFile(dataMap["profileImageUrl"], user.uid)
            : null;
        user.uid = matchUserUID;
        return user;
      }
    }
    return null;
  }

  @override
  Future<List<CurrentUser>> fetchAllUsersWithAppliedFilters() async {
    /* This is the function that is called in DiscoverScreen(), ONLY for the first time. 
       It applies filters as per preferences set by the user in the sign up process*/
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
          querySnapshot
              .docs; //Get all the documents from UserActivityCollection

      List<CurrentUser> usersList = await CurrentUser.toCurrentList(
          listSnapShots); // Convert the List of documents from Firebase collection to the List<CurrentUser>
      /*
      Show the users whose age is in between +3 and -3 of the user's age.
      For example, if user's age is 21, then user will be able to see all users, whose age is in between 18(21-3) and 24(21+3)
      */ 
      num _minAge = SessionConstants.sessionUser.age! - 3 <= 18 // If SessionUser's age -3 results in a number less than 18, then minimum age is set to 18
          ? 18
          : SessionConstants.sessionUser.age! - 3;
      num _maxAge = SessionConstants.sessionUser.age! + 3;
      SessionConstants.appliedFilters = AppliedFilters(// AppliedFilters is the class which is used to apply filters in the app 
          minAge: _minAge,
          maxAge: _maxAge,
          thresholdDist: 5,
          interestedIn: SessionConstants.sessionUser.interestedin!);
      SessionConstants.defaultFilters = SessionConstants.appliedFilters;// Assigning the default filters value here, after the calculation of the minAge and maxAge of the user
      // This for loop is to get the list of all the interacted users
      for (var i = 0; i < usersList.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> doc = await collection
            .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
            .collection("InteractedUsers")
            .doc(usersList[i].uid)
            .get();
        if (doc.exists) {
          usersList.removeAt(i);// Remove all the interacted users from the allUsersList
        }
      }
      // Iterate through usersList to remove all the users whose distance is greater than 5KM and those who do not fit in the preferences as laid out by the user during the sign up process
      usersList.removeWhere((user) {
        bool isDistanceGreaterthan5KM = false;

        if (user.locationCoordinates != null) {
          double? distanceInKilometers =
              calculateDistance(user.locationCoordinates!);
          user.distance = distanceInKilometers;
          if (distanceInKilometers != null) {
            isDistanceGreaterthan5KM = distanceInKilometers > 5;
          }
        }
        if ((user.uid ==
                SharedObjects.prefs?.getString(SessionConstants.sessionUid)) ||
            isDistanceGreaterthan5KM ||
            (SessionConstants.sessionUser.interestedin != GENDER.both &&
                user.gender != SessionConstants.sessionUser.interestedin) ||
            (user.age != null &&
                (user.age! < _minAge || user.age! > _maxAge))) {
          return true;// user will be removed from the allUsersList
        }

        return false;
      });
      return usersList; // Return all the remaining users after applying filters
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
          for (var i = 0; i < imageUrls.length; i++) {
            user.images ??= [];
            user.images!
                .add(await urlToFile(imageUrls[i], uid! + (i + 1).toString()));
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

    // Get the location of the SessionUser
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

  // Called whenever user applies the filter 
  @override
  Future<List<CurrentUser>> filterChanged(
      num minAge, num maxAge, num thresholdDist, GENDER interestedIn) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
        querySnapshot.docs;//Fetch all the users from the Firestore Database

    List<CurrentUser> usersList =
        await CurrentUser.toCurrentList(listSnapShots);// Convert list of documents to List<CurrentUser>

    // Below for loop removes all the interacted Users from the usersList declared above
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
    // Remove all the users who do not fit in the applied filters by the user
    usersList.removeWhere((user) {
      // Remove self from the allUsersList
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
    return usersList;//Return list with applied filters
  }

  // Get the Stream of all Users present in the Firestore Database 
  @override
  Stream<List<CurrentUser>> fetchAllUsers() {
    try {
      return collection.snapshots().transform(
            StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
                List<CurrentUser>>.fromHandlers(
              handleData: (QuerySnapshot<Map<String, dynamic>> querySnapshot,
                      EventSink<List<CurrentUser>> sink) =>
                  mapQueryToConversation(querySnapshot, sink),
            ),
          );
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
