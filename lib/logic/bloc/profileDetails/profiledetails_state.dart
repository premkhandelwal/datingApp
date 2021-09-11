part of 'profiledetails_bloc.dart';

@immutable
abstract class ProfiledetailsState {}

class ProfiledetailsInitial extends ProfiledetailsState {}

class AddedBasicInfoState extends ProfiledetailsState {}

class AddedGenderInfoState extends ProfiledetailsState {}

class AddedInterestsInfoState extends ProfiledetailsState {}

class AddingInfoState extends ProfiledetailsState {}

class SubmittingInfoState extends ProfiledetailsState {}

class SubmittedInfoState extends ProfiledetailsState {}

class FailedtoSubmitInfoState extends ProfiledetailsState {}

class FailedtoAddInfoState extends ProfiledetailsState {}

class FetchingInfoState extends ProfiledetailsState {}

class FetchedInfoState extends ProfiledetailsState {
  final CurrentUser currentUser;

  FetchedInfoState({required this.currentUser});
}

class FailedFetchInfoState extends ProfiledetailsState {}

class FetchedLocationInfo extends ProfiledetailsState {
  final String? locationInfo;

  FetchedLocationInfo({required this.locationInfo});
}

class FailedFetchLocationInfoState extends ProfiledetailsState{}
