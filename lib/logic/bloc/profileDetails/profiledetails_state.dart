part of 'profiledetails_bloc.dart';

@immutable
abstract class ProfiledetailsState {}

class ProfiledetailsInitial extends ProfiledetailsState {}

class AddedBasicInfoState extends ProfiledetailsState{}

class AddedGenderInfoState extends ProfiledetailsState{}

class AddedInterestsInfoState extends ProfiledetailsState{}

class AddingInfoState extends ProfiledetailsState{}

class FailedtoAddInfoState extends ProfiledetailsState{}