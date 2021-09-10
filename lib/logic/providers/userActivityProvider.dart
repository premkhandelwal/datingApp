import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseUserActivityProvider {
  Future<void> userLiked(String selfUID, String likedUserUID);
  Future<void> userDisliked(String userUID, String likedUserUID);
  Future<bool> userFindMatch(String matchUserUID, String selfUID);
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
  }
}
