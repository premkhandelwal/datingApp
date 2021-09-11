part of 'useractivity_bloc.dart';

@immutable
abstract class UseractivityEvent {}

class UserLikedEvent extends UseractivityEvent {
  final String likedUserUID;

  UserLikedEvent( this.likedUserUID);
}

class UserDislikedEvent extends UseractivityEvent {
  final String dislikedUserUID;

  UserDislikedEvent( this.dislikedUserUID);
}

class UserFindMatchEvent extends UseractivityEvent {
  final String matchUserUID;
  UserFindMatchEvent(
     this.matchUserUID,
  );
}

class FetchAllUsersEvent extends UseractivityEvent{}
