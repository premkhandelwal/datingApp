import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class BaseUserActivityProvider {
  Future<void> userLiked(String likedUserUID);
  Future<void> userDisliked(String likedUserUID);
  Future<bool> userFindMatch(String matchUserUID);
  Future<List<CurrentUser>> fetchAllUsers();
  Future<List<CurrentUser>> fetchMatchedUsers();
}

class UserActivityProvider extends BaseUserActivityProvider {
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("UserActivity");

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> userDisliked(String dislikedUserUID) async {
    await collection
        .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
        .collection("DislikedUsers")
        .doc(dislikedUserUID)
        .set({dislikedUserUID: DateTime.now()});
  }

  @override
  Future<bool> userFindMatch(String matchUserUID) async {
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

    return exist;
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
  Future<List<CurrentUser>> fetchAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
          querySnapshot.docs;
     
      List<CurrentUser> usersList = CurrentUser.toCurrentList(listSnapShots);
     

      usersList.removeWhere((element) =>
          element.uid ==
          SharedObjects.prefs?.getString(SessionConstants.sessionUid));
      SessionConstants.allUsers = usersList;
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
      List<CurrentUser> usersList = CurrentUser.toCurrentList(listSnapShots);
      print(usersList);
      print(usersList[0].name);
      return usersList;
    } catch (e) {
      throw Exception(e);
    }
/*       QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
          .doc(SharedObjects.prefs?.getString(SessionConstants.sessionUid))
          .collection("MatchedUsers")
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> listSnapShots =
          querySnapshot.docs;

      List<String> ids = [];
      listSnapShots.forEach((element) async{
        QuerySnapshot<Map<String, dynamic>> querySnapshot1 =await  collection.doc(element.id).collection("MatchedUsers").get();
        List<QueryDocumentSnapshot<Map<String, dynamic>>> listquerySnapshot = querySnapshot1.docs;
      List<CurrentUser> usersList = CurrentUser.toCurrentList(listquerySnapshot);
  
      });
      List<CurrentUser> usersList = CurrentUser.toCurrentList(listSnapShots);
      print(usersList);
      print(usersList[0].name);
      return usersList; */
  }
}
