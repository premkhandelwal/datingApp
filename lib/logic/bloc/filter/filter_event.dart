part of 'filter_bloc.dart';

@immutable
abstract class FilterEvent {}

class AgeFilterChangedEvent extends FilterEvent {
  final num minAge;
  final num maxAge;
  AgeFilterChangedEvent({
    required this.minAge,
    required this.maxAge,
  });
}

class GenderFilterChangedEvent extends FilterEvent {
  final GENDER interestedIn;
  GenderFilterChangedEvent({
    required this.interestedIn,
  });
}

class DistanceFilterChangedEvent extends FilterEvent {
  final num thresholdDist;
  DistanceFilterChangedEvent({
    required this.thresholdDist,
  });
}

class FilterClearedEvent extends FilterEvent {}
