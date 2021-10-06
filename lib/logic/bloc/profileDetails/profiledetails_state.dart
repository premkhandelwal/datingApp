part of 'profiledetails_bloc.dart';

@immutable
abstract class ProfiledetailsState {}

class ProfiledetailsInitial extends ProfiledetailsState {}

class AddedBasicInfoState extends ProfiledetailsState {}

class AddedGenderInfoState extends ProfiledetailsState {}

class AddedInterestedInInfoState extends ProfiledetailsState {}

class AddedInterestsInfoState extends ProfiledetailsState {}

class AddingInfoState extends ProfiledetailsState {}

class SubmittingInfoState extends ProfiledetailsState {}

class SubmittedInfoState extends ProfiledetailsState {}

class FailedtoSubmitInfoState extends ProfiledetailsState {}

class UpdatingInfoState extends ProfiledetailsState {}

class UpdatedInfoState extends ProfiledetailsState {
  final CurrentUser currentUser;

  UpdatedInfoState({required this.currentUser});
}

class FailedtoUpdateInfoState extends ProfiledetailsState {}

class FailedtoAddInfoState extends ProfiledetailsState {}

class DataLoadingInProgressState extends ProfiledetailsState {}

class ShowMoreState extends ProfiledetailsState {
  final bool isBio;
  final bool isInterests;
  ShowMoreState({
    required this.isBio,
    required this.isInterests,
  });
}
