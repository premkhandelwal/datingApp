part of 'useractivity_bloc.dart';

@immutable
abstract class UseractivityState {}

class UseractivityInitial extends UseractivityState {}

class UserLikedState extends UseractivityState{}

class UserDislikedState extends UseractivityState{}

class UserMatchFoundState extends UseractivityState{}

class UserMatchNotFoundState extends UseractivityState{}