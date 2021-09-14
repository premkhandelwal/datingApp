part of 'useractivity_bloc.dart';

@immutable
abstract class UseractivityState {}

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
