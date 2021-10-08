import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/profileDetailsProvider.dart';
import 'package:dating_app/logic/providers/userActivityProvider.dart';
import 'package:dating_app/logic/repositories/baseRepo.dart';

class ProfileDetailsRepository extends BaseRepository {
  final ProfileDetailsProvider profileDetailsProvider =
      ProfileDetailsProvider();
  final UserActivityProvider userActivityProvider = UserActivityProvider();

  /* Future<void> addBasicInfo(CurrentUser user) =>
      profileDetailsProvider.addBasicInfo(user);
  Future<void> addGenderInfo(CurrentUser user) =>
      profileDetailsProvider.addGenderInfo(user); */
  Future<void> updateUserInfo(CurrentUser user) =>
      profileDetailsProvider.updateUserInfo(user);
  Future<void> submitUserInfo(CurrentUser user) =>
      profileDetailsProvider.submitUserInfo(user);
  Future<Map<String, num>> fetchLocInfo() => userActivityProvider.fetchLocationInfo();
  Future<CurrentUser> fetchUserInfo(Map<String, num> locationCoordinates) => userActivityProvider.fetchUserInfo(locationCoordinates);

  @override
  void dispose() {}
}
