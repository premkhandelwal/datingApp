import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:meta/meta.dart';
import 'package:dating_app/const/app_const.dart';
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
    } else if (event is FilterClearedEvent) {
      yield* _mapClearFiltertoState();
    }
  }

  Stream<FilterState> _mapAgeFilterEventtoState(
      AgeFilterChangedEvent event) async* {
    filterRepository.ageFilterChanged(event.minAge, event.maxAge);
    yield AppliedFilters();
  }

  Stream<FilterState> _mapDistanceFilterEventtoState(
      DistanceFilterChangedEvent event) async* {
    filterRepository.distanceFilterChanged(event.thresholdDist);
    yield AppliedFilters();
  }

  Stream<FilterState> _mapGenderFilterEventtoState(
      GenderFilterChangedEvent event) async* {
    filterRepository.interestedInChanged(event.interestedIn);
    yield AppliedFilters();
  }

  Stream<FilterState> _mapClearFiltertoState() async* {
    filterRepository.clearAllFilters();
    yield ClearedFilters();
  }
}
