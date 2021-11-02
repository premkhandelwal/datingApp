import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:meta/meta.dart';

import 'package:dating_app/logic/repositories/userActivityRepo.dart';

part 'useractivity_event.dart';
part 'useractivity_state.dart';

class UseractivityBloc extends Bloc<UseractivityEvent, UseractivityState> {
  final UserActivityRepository userActivityRepository;
  StreamSubscription? userDetailsSubsciption;
  UseractivityBloc({
    required this.userActivityRepository,
  }) : super(UseractivityInitial());

  @override
  Future<void> close() {
    userDetailsSubsciption?.cancel();
    return super.close();
  }

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
    } else if (event is FetchAllUsersWithAppliedFiltersEvent) {
      yield* _mapFetchUserswithFiltersEventtoState();
    } else if (event is FetchAllUsersEvent) {
      yield* _mapFetchUserEventtoState();
    } else if (event is RecievedAllUsersEvent) {
      yield FetchedAllUsersState(users: event.users);
    } else if (event is FetchMatchedUsersEvent) {
      yield* _mapFetchMatchedUsersEventtoState();
    } else if (event is FetchInfoEvent) {
      yield* _mapFetchInfotoState(event);
    } else if (event is FetchLocationInfoEvent) {
      yield* _mapFetchLocationInfotoState(event);
    } else if (event is UpdateLocationInfoEvent) {
      yield* _mapUpdateLocationInfotoState(event);
    } else if (event is FilterChangedEvent) {
      yield* _mapFilterEventtoState(event);
    } else if (event is ClearedFiltersEvent) {
      yield* _mapClearFiltertoState();
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

  Stream<UseractivityState> _mapFetchUserswithFiltersEventtoState() async* {
    yield FetchingAllUsersState();
    try {
      List<CurrentUser> _users =
          await userActivityRepository.fetchAllUsersWithAppliedFilters();
      yield FetchedAllUserswithFiltersState(users: _users);
      add(UpdateLocationInfoEvent());
    } catch (e) {
      yield FailedToFetchAllUsersState();
    }
  }

  Stream<UseractivityState> _mapFetchUserEventtoState() async* {
    yield FetchingAllUsersState();
    try {
      userDetailsSubsciption =
          userActivityRepository.fetchAllUsers().listen((users) {
        add(RecievedAllUsersEvent(users: users));
      });
    } catch (e) {
      yield FailedToFetchAllUsersState();
    }
  }

  Stream<UseractivityState> _mapFetchMatchedUsersEventtoState() async* {
    try {
      List<CurrentUser> _users =
          await userActivityRepository.fetchMatchedUsers();
      yield FetchedMatchedUsersState(users: _users);
    } catch (e) {
      yield FailedToFetchAllUsersState();
    }
  }

  Stream<UseractivityState> _mapFetchInfotoState(FetchInfoEvent event) async* {
    yield FetchingInfoState();
    try {
// Pass location coordinates to fetchuserinfo() because the new location of the user is not updated in the database yet
      CurrentUser currentUser =
          await userActivityRepository.fetchUserInfo(event.locationCoordinates);
      yield FetchedInfoState(currentUser: currentUser);
      add(FetchAllUsersWithAppliedFiltersEvent());
    } catch (e) {
      yield FailedFetchInfoState();
    }
  }

  Stream<UseractivityState> _mapFetchLocationInfotoState(
      FetchLocationInfoEvent event) async* {
    yield FetchingInfoState();
    try {
      Map<String, num> locationInfo =
          await userActivityRepository.fetchLocationInfo();
      yield FetchedLocationInfoState(locationInfo: locationInfo);
      add(FetchInfoEvent(locationCoordinates: locationInfo));
    } catch (e) {
      yield FailedFetchInfoState();
    }
  }

  Stream<UseractivityState> _mapUpdateLocationInfotoState(
      UpdateLocationInfoEvent event) async* {
    yield UpdatingLocationInfoState();
    try {
      userActivityRepository.updateLocationInfo();
      yield UpdatedLocInfoState();
    } catch (e) {}
  }

  Stream<UseractivityState> _mapFilterEventtoState(
      FilterChangedEvent event) async* {
    yield ApplyingFilters();
    List<CurrentUser> users = await userActivityRepository.filterChanged(
        event.minAge, event.maxAge, event.thresholdDist, event.interestedIn);
    yield AppliedFiltersState(usersList: users);
  }

  Stream<UseractivityState> _mapClearFiltertoState() async* {
    yield ClearedFiltersState();
  }
}
