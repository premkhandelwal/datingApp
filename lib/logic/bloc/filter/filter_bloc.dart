import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:meta/meta.dart';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/bloc/userActivity/useractivity_bloc.dart';
import 'package:dating_app/logic/repositories/filterRepo.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final FilterRepository filterRepository;
  FilterBloc({
    required this.filterRepository,
  }) : super(FilterInitial());

  @override
  Stream<FilterState> mapEventToState(
    FilterEvent event,
  ) async* {
    if (event is AgeFilterChangedEvent) {
      yield* _mapAgeFilterEventtoState(event);
    } else if (event is DistanceFilterChangedEvent) {
      yield* _mapDistanceFilterEventtoState(event);
    } else if (event is GenderFilterChangedEvent) {
      yield* _mapGenderFilterEventtoState(event);
    }
  }

  Stream<FilterState> _mapAgeFilterEventtoState(
      AgeFilterChangedEvent event) async* {
    List<CurrentUser> filteredUsers = filterRepository.ageFilterChanged(event.minAge, event.maxAge);
    yield AppliedFilters(user: filteredUsers);
  }

  Stream<FilterState> _mapDistanceFilterEventtoState(
      DistanceFilterChangedEvent event) async* {
    List<CurrentUser> filteredUsers = filterRepository.distanceFilterChanged(event.thresholdDist);
    yield AppliedFilters(user: filteredUsers);
  }

  Stream<FilterState> _mapGenderFilterEventtoState(
      GenderFilterChangedEvent event) async* {
    List<CurrentUser> filteredUsers = filterRepository.interestedInChanged(event.interestedIn);
    yield AppliedFilters(user: filteredUsers);
  }
}
