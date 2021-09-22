part of 'filter_bloc.dart';

@immutable
abstract class FilterState {}

class FilterInitial extends FilterState {}

class ApplyingFilters extends FilterState {}

class AppliedFilters extends FilterState {}
class ClearedFilters extends FilterState {}

class FailedToApplyFilters extends FilterState {}
