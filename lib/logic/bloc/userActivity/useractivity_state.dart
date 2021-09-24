part of 'useractivity_bloc.dart';


 class UseractivityState {}

class UseractivityInitial extends UseractivityState {}

class UserLikedState extends UseractivityState {}

class UserDislikedState extends UseractivityState {}

class UserMatchFoundState extends UseractivityState {
  final CurrentUser user;
  UserMatchFoundState({
    required this.user,
  });
}

class UserMatchNotFoundState extends UseractivityState {}

class FetchingMatchedUsersState extends UseractivityState {}

class FetchedMatchedUsersState extends UseractivityState {
  final List<CurrentUser> users;

  FetchedMatchedUsersState({required this.users});
}

class FailedtoMatchUsersState extends UseractivityState {}

class FetchedAllUsersState extends UseractivityState {
  final List<CurrentUser> users;

  FetchedAllUsersState({required this.users});
}

class FailedToFetchAllUsersState extends UseractivityState {}

class FetchingAllUsersState extends UseractivityState {}

class FetchingInfoState extends UseractivityState {}

class FetchedInfoState extends UseractivityState {
  final CurrentUser currentUser;

  FetchedInfoState({required this.currentUser});
}

class FailedFetchInfoState extends UseractivityState {}

class FetchedLocationInfoState extends UseractivityState {
  final Map<String,num> locationInfo;

  FetchedLocationInfoState({required this.locationInfo});
}

class FailedFetchLocationInfoState extends UseractivityState{}

class FailedUpdateLocInfoState extends UseractivityState {}

class UpdatedLocInfoState extends UseractivityState {}

class UpdatingLocationInfoState extends UseractivityState{}

class AppliedFiltersState extends UseractivityState{}
class ClearedFiltersState extends UseractivityState{}

class ApplyingFilters extends UseractivityState {}


class FailedToApplyFilters extends UseractivityState {}