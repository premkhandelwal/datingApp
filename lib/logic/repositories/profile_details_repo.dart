import 'dart:io';

import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/profile_details_provider.dart';
import 'package:dating_app/logic/providers/user_activity_provider.dart';
import 'package:dating_app/logic/repositories/base_repo.dart';

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
  Future<void> uploadImages(List<File> images) => profileDetailsProvider.uploadImages(images);


  @override
  void dispose() {}
}
