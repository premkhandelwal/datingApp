import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/profileDetailsProvider.dart';
import 'package:dating_app/logic/repositories/baseRepo.dart';

class ProfileDetailsRepository extends BaseRepository {
  final ProfileDetailsProvider profileDetailsProvider =
      ProfileDetailsProvider();

  Future<void> addBasicInfo(CurrentUser user) =>
      profileDetailsProvider.addBasicInfo(user);
  Future<void> addGenderInfo(CurrentUser user) =>
      profileDetailsProvider.addGenderInfo(user);
  Future<void> addInterestInfo(CurrentUser user) =>
      profileDetailsProvider.addInterestInfo(user);

  @override
  void dispose() {}
}
