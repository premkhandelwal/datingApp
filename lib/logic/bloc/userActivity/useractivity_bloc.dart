import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/data/user.dart';
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
    if (event is UserStateNoneEvent) {
      yield UseractivityInitial();
    } else if (event is UserLikedEvent) {
      yield* _mapUserLikedeventTostate(event);
    } else if (event is UserDislikedEvent) {
      yield* _mapUserDisLikedeventTostate(event);
    } else if (event is UserFindMatchEvent) {
      yield* _mapUserMatchFoundeventTostate(event);
    } else if (event is FetchAllUsersWithAppliedFiltersEvent) {
      yield* _mapFetchUserswithFiltersEventtoState();
    } else if (event is FetchAllUsersEvent) {
      yield* _mapFetchUserEventtoState();
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
    await userActivityRepository.userLiked(event.likedUserUID);
    yield UserLikedState();
  }

  Stream<UseractivityState> _mapUserDisLikedeventTostate(
      UserDislikedEvent event) async* {
    await userActivityRepository.userDisliked(event.dislikedUserUID);
    yield UserDislikedState();
  }

  Stream<UseractivityState> _mapUserMatchFoundeventTostate(
      UserFindMatchEvent event) async* {
    CurrentUser? x =
        await userActivityRepository.userFindMatch(event.matchUserUID);
    print("xMatches ?");
    print(x);
    if (x != null) {
      yield UserMatchFoundState(user: x);
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
    } catch (e) {
      yield FailedToFetchAllUsersState();
    }
  }

  Stream<UseractivityState> _mapFetchUserEventtoState() async* {
    yield FetchingAllUsersState();
    try {
      List<CurrentUser> _users = await userActivityRepository.fetchAllUsers();
      yield FetchedAllUsersState(users: _users);
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
      CurrentUser currentUser = await userActivityRepository.fetchUserInfo();
      yield FetchedInfoState(currentUser: currentUser);
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
    } catch (e) {
      yield FailedFetchInfoState();
    }
  }

  Stream<UseractivityState> _mapUpdateLocationInfotoState(
      UpdateLocationInfoEvent event) async* {
    yield UpdatingLocationInfoState();
    try {
      await userActivityRepository
          .updateLocationInfo(event.locationCoordinates);
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
    userActivityRepository.clearAllFilters();
    yield ClearedFiltersState();
  }
}
