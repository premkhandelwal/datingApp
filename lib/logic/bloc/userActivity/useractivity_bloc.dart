import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:dating_app/logic/repositories/userActivityRepo.dart';

part 'useractivity_event.dart';
part 'useractivity_state.dart';

class UseractivityBloc extends Bloc<UseractivityEvent, UseractivityState> {
  final UserActivityRepository userActivityRepository;
  UseractivityBloc({
    required this.userActivityRepository,
  }) : super(UseractivityInitial());

  @override
  Stream<UseractivityState> mapEventToState(
    UseractivityEvent event,
  ) async* {
    if (event is UserLikedEvent) {
      yield* _mapUserLikedeventTostate(event);
    } else if (event is UserDislikedEvent) {
      yield* _mapUserDisLikedeventTostate(event);
    } else if (event is UserFindMatchEvent) {
      yield* _mapUserMatchFoundeventTostate(event);
    }
  }

  Stream<UseractivityState> _mapUserLikedeventTostate(
      UserLikedEvent event) async* {
    await userActivityRepository.userLiked(event.userUID, event.likedUserUID);
    yield UserLikedState();
  }

  Stream<UseractivityState> _mapUserDisLikedeventTostate(
      UserDislikedEvent event) async* {
    await userActivityRepository.userDisliked(
        event.userUID, event.dislikedUserUID);
    yield UserDislikedState();
  }

  Stream<UseractivityState> _mapUserMatchFoundeventTostate(
      UserFindMatchEvent event) async* {
    bool x = await userActivityRepository.userFindMatch(
        event.matchUserUID, event.selfUID);
    print("xMatches ?");
    print(x);
    if (x) {
      yield UserMatchFoundState();
    } else {
      yield UserMatchNotFoundState();
    }
  }
}
