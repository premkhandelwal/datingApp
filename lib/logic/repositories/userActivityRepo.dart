import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/userActivityProvider.dart';
import 'package:dating_app/logic/repositories/baseRepo.dart';

class UserActivityRepository extends BaseRepository {
  UserActivityProvider activityProvider = UserActivityProvider();
  Future<void> userLiked(String likedUserUID) => activityProvider.userLiked(likedUserUID);
  Future<void> userDisliked(String dislikedUserUID) => activityProvider.userDisliked(dislikedUserUID);
  Future<CurrentUser?> userFindMatch(String matchUserUID,) => activityProvider.userFindMatch(matchUserUID);
    Future<void> updateLocationInfo(Map<String, num> locationCoordinates) =>
      activityProvider.updateLocationInfo(locationCoordinates);
  Future<List<CurrentUser>> fetchMatchedUsers() => activityProvider.fetchMatchedUsers();
  Future<List<CurrentUser>> fetchAllUsers() => activityProvider.fetchAllUsers();
Future<CurrentUser> fetchUserInfo() => activityProvider.fetchUserInfo();
  Future<Map<String,num>> fetchLocationInfo() =>
      activityProvider.fetchLocationInfo();
      Future<List<CurrentUser>> interestedInChanged(GENDER interestedIn) async =>
    await  activityProvider.interestedInChanged(interestedIn);
  Future<List<CurrentUser>> distanceFilterChanged(num threshHoldDist) async =>
     await activityProvider.distanceFilterChanged(threshHoldDist);
  Future<List<CurrentUser>> ageFilterChanged(num minAge, num maxAge) async =>
     await  activityProvider.ageFilterChanged(minAge, maxAge);
  void clearAllFilters() => activityProvider.clearAllFilters();
  @override
  void dispose() {}
}
