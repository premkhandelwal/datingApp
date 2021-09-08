import 'package:dating_app/logic/providers/userActivityProvider.dart';
import 'package:dating_app/logic/repositories/baseRepo.dart';

class UserActivityRepository extends BaseRepository {
  UserActivityProvider activityProvider = UserActivityProvider();
  Future<void> userLiked(String userUID, String likedUserUID) => activityProvider.userLiked(userUID,likedUserUID);
  Future<void> userDisliked(String userUID, String dislikedUserUID) => activityProvider.userDisliked(userUID,dislikedUserUID);
  Future<bool> userFindMatch(String matchUserUID, String selfUID) => activityProvider.userFindMatch(matchUserUID,selfUID);

  @override
  void dispose() {}
}
