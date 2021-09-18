part of 'filter_bloc.dart';

@immutable
abstract class FilterState {}

class FilterInitial extends FilterState {}

class ApplyingFilters extends FilterState {}

class AppliedFilters extends FilterState {
  final List<CurrentUser> user;
  AppliedFilters({
    required this.user,
  });
}

class FailedToApplyFilters extends FilterState {}
