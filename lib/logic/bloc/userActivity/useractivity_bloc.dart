import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/filter/filter_bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:meta/meta.dart';

import 'package:dating_app/logic/repositories/userActivityRepo.dart';

part 'useractivity_event.dart';
part 'useractivity_state.dart';

class UseractivityBloc extends Bloc<UseractivityEvent, UseractivityState> {
  final UserActivityRepository userActivityRepository;
  final FilterBloc filterBloc;
  StreamSubscription? filterSubscription;
  UseractivityBloc({
    required this.userActivityRepository,
    required this.filterBloc,
  }) : super(UseractivityInitial()) {
    print("heeeeelo");
    filterSubscription = filterBloc.stream.listen((state) {
      print("state $state");
      if (state is AppliedFilters) {
        add(AppliedFiltersEvent());
      }
    });
  }

  @override
  Future<void> close() {
    filterSubscription?.cancel();
    return super.close();
  }

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
    } else if (event is FetchAllUsersEvent) {
      yield* _mapFetchUsersEventtoState();
    } else if (event is FetchMatchedUsersEvent) {
      yield* _mapFetchMatchedUsersEventtoState();
    } else if (event is FetchInfoEvent) {
      yield* _mapFetchInfotoState(event);
    } else if (event is FetchLocationInfoEvent) {
      yield* _mapFetchLocationInfotoState(event);
    } else if (event is UpdateLocationInfoEvent) {
      yield* _mapUpdateLocationInfotoState(event);
    } else if (event is AppliedFiltersEvent) {
      yield AppliedFiltersState();
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
    bool x = await userActivityRepository.userFindMatch(event.matchUserUID);
    print("xMatches ?");
    print(x);
    if (x) {
      yield UserMatchFoundState(
          user: SessionConstants.allUsers
              .firstWhere((element) => element.uid == event.matchUserUID));
    } else {
      yield UserMatchNotFoundState();
    }
  }

  Stream<UseractivityState> _mapFetchUsersEventtoState() async* {
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
}
