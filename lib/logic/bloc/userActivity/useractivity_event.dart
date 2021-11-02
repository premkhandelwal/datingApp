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

class FetchInfoEvent extends UseractivityEvent {
  final Map<String, num> locationCoordinates;
  FetchInfoEvent({
    required this.locationCoordinates,
  });
}

class UpdateLocationInfoEvent extends UseractivityEvent {}

class AppliedFiltersEvent extends UseractivityEvent{}
class ClearedFiltersEvent extends UseractivityEvent{}

class FilterChangedEvent extends UseractivityEvent {
  final num minAge;
  final num maxAge;
  final GENDER interestedIn;
  final num thresholdDist;

  FilterChangedEvent({
    required this.minAge,
    required this.maxAge,
    required this.interestedIn,
    required this.thresholdDist,

  });
}



