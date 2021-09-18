import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/data/user.dart';

abstract class BaseFilterProvider {
  List<CurrentUser> interestedInChanged(GENDER gender);
  List<CurrentUser> distanceFilterChanged(num thresholdDist);
  List<CurrentUser> ageFilterChanged(num minAge, num maxAge);
}

class FilterProvider extends BaseFilterProvider {
  @override
  List<CurrentUser> ageFilterChanged(num minAge, num maxAge) {
    List<CurrentUser> filteredUsers = SessionConstants.filteredUsers;
    filteredUsers.retainWhere((user) {
      if (user.age != null) {
        return (minAge <= user.age! && user.age! <= maxAge);
      }
      return true;
    });
    return filteredUsers;
  }

  @override
  List<CurrentUser> distanceFilterChanged(num thresholdDist) {
    List<CurrentUser> filteredUsers = SessionConstants.filteredUsers;
    filteredUsers.removeWhere((user) {
      if (user.locationCoordinates != null) {
        num? distance = calculateDistance(user.locationCoordinates!);
        if (distance != null) {
          return distance > thresholdDist;
        }
        return false;
      }
      return false;
    });
    return filteredUsers;
  }

  @override
  List<CurrentUser> interestedInChanged(GENDER interestedIn) {
    List<CurrentUser> filteredUsers = SessionConstants.filteredUsers;
    if (interestedIn != GENDER.both) {
      filteredUsers.retainWhere((user) {
        print(user.gender);
        return user.gender == interestedIn;
      });
    }
    return filteredUsers;
  }
}
