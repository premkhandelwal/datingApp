import 'package:dating_app/const/app_const.dart';

class AppliedFilters {
  final num minAge;
  final num maxAge;
  final GENDER interestedIn;
  final num thresholdDist;

  AppliedFilters({
    required this.minAge,
    required this.maxAge,
    required this.interestedIn,
    required this.thresholdDist,

  });
}