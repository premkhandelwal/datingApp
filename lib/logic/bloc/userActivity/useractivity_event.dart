part of 'useractivity_bloc.dart';

@immutable
abstract class UseractivityEvent {}

class UserLikedEvent extends UseractivityEvent {
  final String userUID;
  final String likedUserUID;

  UserLikedEvent(this.userUID, this.likedUserUID);
}

class UserDislikedEvent extends UseractivityEvent {
  final String userUID;
  final String dislikedUserUID;

  UserDislikedEvent(this.userUID, this.dislikedUserUID);
}

class UserFindMatchEvent extends UseractivityEvent {
  final String matchUserUID;
  final String selfUID;
  UserFindMatchEvent(
     this.matchUserUID,
     this.selfUID,
  );
}
