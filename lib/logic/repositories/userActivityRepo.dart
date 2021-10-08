import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/userActivityProvider.dart';
import 'package:dating_app/logic/repositories/baseRepo.dart';

class UserActivityRepository extends BaseRepository {
  UserActivityProvider activityProvider = UserActivityProvider();
  Future<void> userLiked(String likedUserUID) => activityProvider.userLiked(likedUserUID);
  Future<void> userDisliked(String dislikedUserUID) => activityProvider.userDisliked(dislikedUserUID);
  Future<CurrentUser?> userFindMatch(String matchUserUID,) => activityProvider.userFindMatch(matchUserUID);
    Future<void> updateLocationInfo() =>
      activityProvider.updateLocationInfo();
  Future<List<CurrentUser>> fetchMatchedUsers() => activityProvider.fetchMatchedUsers();
  Future<List<CurrentUser>> fetchAllUsers() => activityProvider.fetchAllUsers();
  Future<List<CurrentUser>> fetchAllUsersWithAppliedFilters() => activityProvider.fetchAllUsersWithAppliedFilters();
Future<CurrentUser> fetchUserInfo(Map<String, num> locationCoordinates) => activityProvider.fetchUserInfo(locationCoordinates);
  Future<Map<String,num>> fetchLocationInfo() =>
      activityProvider.fetchLocationInfo();
/*       Future<List<CurrentUser>> interestedInChanged(GENDER interestedIn) async =>
    await  activityProvider.interestedInChanged(interestedIn);
  Future<List<CurrentUser>> distanceFilterChanged(List<CurrentUser> usersList,num threshHoldDist) async =>
     await activityProvider.distanceFilterChanged(usersList,threshHoldDist);
 */  Future<List<CurrentUser>> filterChanged(num minAge, num maxAge,num thresholdDist, GENDER interestedIn) async =>
     await  activityProvider.filterChanged(minAge, maxAge,thresholdDist,interestedIn);
  void clearAllFilters() => activityProvider.clearAllFilters();
  @override
  void dispose() {}
}
