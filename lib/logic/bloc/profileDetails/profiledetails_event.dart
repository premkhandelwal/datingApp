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

class SubmitInfoEvent extends ProfiledetailsEvent{}

class UpdateInfoEvent extends ProfiledetailsEvent{
  final CurrentUser user;
  UpdateInfoEvent({
    required this.user,
  });
}
