import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/filterProvider.dart';
import 'package:dating_app/logic/repositories/baseRepo.dart';

class FilterRepository extends BaseRepository{
FilterProvider filterProvider = FilterProvider();
  List<CurrentUser> interestedInChanged(GENDER interestedIn) => filterProvider.interestedInChanged(interestedIn);
  List<CurrentUser> distanceFilterChanged(num threshHoldDist) => filterProvider.distanceFilterChanged(threshHoldDist);
  List<CurrentUser> ageFilterChanged(num minAge, num maxAge) => filterProvider.ageFilterChanged(minAge, maxAge); 

  @override
  void dispose() {
  }
}