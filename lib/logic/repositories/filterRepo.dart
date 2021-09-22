import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/filterProvider.dart';
import 'package:dating_app/logic/repositories/baseRepo.dart';

class FilterRepository extends BaseRepository {
  FilterProvider filterProvider = FilterProvider();
  void interestedInChanged(GENDER interestedIn) =>
      filterProvider.interestedInChanged(interestedIn);
  void distanceFilterChanged(num threshHoldDist) =>
      filterProvider.distanceFilterChanged(threshHoldDist);
  void ageFilterChanged(num minAge, num maxAge) =>
      filterProvider.ageFilterChanged(minAge, maxAge);
  void clearAllFilters() => filterProvider.clearAllFilters();
  @override
  void dispose() {}
}
