import 'package:dating_app/const/app_const.dart';

abstract class BaseFilterProvider {
  void interestedInChanged(GENDER gender);
  void distanceFilterChanged(num thresholdDist);
  void ageFilterChanged(num minAge, num maxAge);
}

class FilterProvider extends BaseFilterProvider {
  @override
  void ageFilterChanged(num minAge, num maxAge) async {
    SessionConstants.allUsers.retainWhere((user) {
      if (user.age != null) {
        return (minAge <= user.age! && user.age! <= maxAge);
      }
      return true;
    });
  }

  @override
  void distanceFilterChanged(num thresholdDist) {
    SessionConstants.allUsers.removeWhere((user) {
      if (user.locationCoordinates != null) {
        num? distance = calculateDistance(user.locationCoordinates!);
        if (distance != null) {
          return distance > thresholdDist;
        }
        return false;
      }
      return false;
    });
  }

  @override
  void interestedInChanged(GENDER interestedIn) async {
    if (interestedIn != GENDER.both) {
      SessionConstants.allUsers.retainWhere((user) {
        print(user.gender);
        return user.gender == interestedIn;
      });
    }
  }
}
