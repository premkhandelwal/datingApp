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

class FetchingUserInfoState extends ProfiledetailsState {}

class FetchedUserInfoState extends ProfiledetailsState {
  final CurrentUser currentUser;
  FetchedUserInfoState({
    required this.currentUser,
  });
}

class FailedtoFetchUserInfoState extends ProfiledetailsState {}

class FetchingUserLocInfoState extends ProfiledetailsState {}

class FetchedUserLocInfoState extends ProfiledetailsState {}

class FailedtoFetchLocInfoState extends ProfiledetailsState {}

class AddingUserImages extends ProfiledetailsState {}

class AddedUserImages extends ProfiledetailsState {}

class FailedtoAddUserImages extends ProfiledetailsState {
  final Object exceptionMessage;
  FailedtoAddUserImages({
    required this.exceptionMessage,
  });
}
