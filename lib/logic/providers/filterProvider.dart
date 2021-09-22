import 'package:dating_app/const/app_const.dart';

abstract class BaseFilterProvider {
  void interestedInChanged(GENDER gender);
  void distanceFilterChanged(num thresholdDist);
  void ageFilterChanged(num minAge, num maxAge);
  void clearAllFilters();
}

class FilterProvider extends BaseFilterProvider {
  @override
  void ageFilterChanged(num minAge, num maxAge) {
    SessionConstants.allUsers.forEach((user) {
      user.agenotinFilters = null;

      if (user.age != null) {
        if (minAge > user.age! || user.age! > maxAge) {
          user.agenotinFilters = true;
        }
      }
    });
  }

  @override
  void distanceFilterChanged(num thresholdDist) {
    SessionConstants.allUsers.forEach((user) {
      if (user.locationCoordinates != null) {
        num? distance = calculateDistance(user.locationCoordinates!);
        user.distancenotinFilters = null;

        if (distance != null) {
          if (distance > thresholdDist) {
            user.distancenotinFilters = true;
          }
          ;
        }
      }
    });
  }

  @override
  void interestedInChanged(GENDER interestedIn) {
    SessionConstants.allUsers.forEach((user) {
      user.gendernotinFilters = null;
      if (interestedIn != GENDER.both) {
        if (user.gender != interestedIn) {
          user.gendernotinFilters = true;
        }
      }
    });
  }

  @override
  void clearAllFilters() {
    SessionConstants.allUsers.forEach((user) {
      user.gendernotinFilters = null;
      user.agenotinFilters = null;
      user.distancenotinFilters = null;
    });
  }
}
