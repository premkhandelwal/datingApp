part of 'profiledetails_bloc.dart';

@immutable
abstract class ProfiledetailsEvent {}

class AddBasicInfoEvent extends ProfiledetailsEvent {
  final CurrentUser user;
  AddBasicInfoEvent({
    required this.user,
  });
}

class AddGenderInfoEvent extends ProfiledetailsEvent {
  final CurrentUser user;
  AddGenderInfoEvent({
    required this.user,
  });
}

class AddInterestedInInfoEvent extends ProfiledetailsEvent {
  final CurrentUser user;
  AddInterestedInInfoEvent({
    required this.user,
  });
}

class AddInterestsInfoEvent extends ProfiledetailsEvent {
  final CurrentUser user;
  AddInterestsInfoEvent({
    required this.user,
  });
}

class SubmitInfoEvent extends ProfiledetailsEvent {}

class UpdateInfoEvent extends ProfiledetailsEvent {
  final CurrentUser user;
  UpdateInfoEvent({
    required this.user,
  });
}

class DataLoadingInProgress extends ProfiledetailsEvent {}

class ShowMore extends ProfiledetailsEvent {
  final bool isBio;
  final bool isInterests;
  ShowMore({
    required this.isBio,
    required this.isInterests,
  });
}

class FetchUserInfoEvent extends ProfiledetailsEvent {
  final Map<String, num> locationCoordinates;
  FetchUserInfoEvent({
    required this.locationCoordinates,
  });
}

class FetchLocInfoEvent extends ProfiledetailsEvent {}

class AddUserImages extends ProfiledetailsEvent {
  final List<File> images;
  AddUserImages({
    required this.images,
  });
}
