part of 'useractivity_bloc.dart';


 class UseractivityEvent {}

class UserStateNoneEvent extends UseractivityEvent{}

class UserLikedEvent extends UseractivityEvent {
  final String likedUserUID;

  UserLikedEvent(this.likedUserUID);
}

class UserDislikedEvent extends UseractivityEvent {
  final String dislikedUserUID;

  UserDislikedEvent(this.dislikedUserUID);
}

class UserFindMatchEvent extends UseractivityEvent {
  final String matchUserUID;
  UserFindMatchEvent(
    this.matchUserUID,
  );
}

class FetchMatchedUsersEvent extends UseractivityEvent {}

class FetchAllUsersWithAppliedFiltersEvent extends UseractivityEvent {}

class FetchAllUsersEvent extends UseractivityEvent {}

class FetchLocationInfoEvent extends UseractivityEvent {}

class FetchInfoEvent extends UseractivityEvent {}

class UpdateLocationInfoEvent extends UseractivityEvent {
  final Map<String, num> locationCoordinates;
  UpdateLocationInfoEvent({
    required this.locationCoordinates,
  });
}

class AppliedFiltersEvent extends UseractivityEvent{}
class ClearedFiltersEvent extends UseractivityEvent{}

class AgeFilterChangedEvent extends UseractivityEvent {
  final num minAge;
  final num maxAge;
  AgeFilterChangedEvent({
    required this.minAge,
    required this.maxAge,
  });
}

class GenderFilterChangedEvent extends UseractivityEvent {
  final GENDER interestedIn;
  GenderFilterChangedEvent({
    required this.interestedIn,
  });
}

class DistanceFilterChangedEvent extends UseractivityEvent {
  final num thresholdDist;
  DistanceFilterChangedEvent({
    required this.thresholdDist,
  });
}

class FilterClearedEvent extends UseractivityEvent {}
