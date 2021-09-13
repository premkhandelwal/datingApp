import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/repositories/profileDetailsRepo.dart';

part 'profiledetails_event.dart';
part 'profiledetails_state.dart';

class ProfiledetailsBloc
    extends Bloc<ProfiledetailsEvent, ProfiledetailsState> {
  final ProfileDetailsRepository profileDetailsRepository;
  CurrentUser currentUser = CurrentUser();
  ProfiledetailsBloc({
    required this.profileDetailsRepository,
  }) : super(ProfiledetailsInitial());

  @override
  Stream<ProfiledetailsState> mapEventToState(
    ProfiledetailsEvent event,
  ) async* {
    if (event is AddBasicInfoEvent) {
      yield* _mapAddBasicInfoEventtoState(event);
    } else if (event is AddGenderInfoEvent) {
      yield* _mapAddGenderInfoEventtoState(event);
    } else if (event is AddInterestsInfoEvent) {
      yield* _mapAddInterestInfoEventtoState(event);
    } else if (event is SubmitInfoEvent) {
      yield* _mapSubmitInfoEventtoState(event);
    } else if (event is FetchInfoEvent) {
      yield* _mapFetchInfotoState(event);
    } else if (event is FetchLocationInfoEvent) {
      yield* _mapFetchLocationInfotoState(event);
    } else if (event is UpdateInfoEvent) {
      yield* _mapUpdateInfotoState(event);
    }
  }

  Stream<ProfiledetailsState> _mapAddBasicInfoEventtoState(
      AddBasicInfoEvent event) async* {
    try {
      yield AddingInfoState();
      currentUser.name = event.user.name;
      currentUser.profession = event.user.profession;
      currentUser.birthDate = event.user.birthDate;
      currentUser.age = event.user.age;
      // await profileDetailsRepository.addBasicInfo(event.user);
      yield AddedBasicInfoState();
    } catch (e) {
      yield FailedtoAddInfoState();
    }
  }

  Stream<ProfiledetailsState> _mapAddGenderInfoEventtoState(
      AddGenderInfoEvent event) async* {
    try {
      yield AddingInfoState();
      currentUser.gender = event.user.gender;
      // await profileDetailsRepository.addGenderInfo(event.user);
      yield AddedGenderInfoState();
    } catch (e) {
      yield FailedtoAddInfoState();
    }
  }

  Stream<ProfiledetailsState> _mapAddInterestInfoEventtoState(
      AddInterestsInfoEvent event) async* {
    try {
      yield AddingInfoState();
      currentUser.interests = event.user.interests;

      // await profileDetailsRepository.addUserInfo(event.user);
      yield AddedInterestsInfoState();
    } catch (e) {
      yield FailedtoAddInfoState();
    }
  }

  Stream<ProfiledetailsState> _mapSubmitInfoEventtoState(
      SubmitInfoEvent event) async* {
    try {
      yield SubmittingInfoState();
      await profileDetailsRepository.submitUserInfo(currentUser);
      yield SubmittedInfoState();
    } catch (e) {
      yield FailedtoSubmitInfoState();
    }
  }

  Stream<ProfiledetailsState> _mapFetchInfotoState(
      FetchInfoEvent event) async* {
    yield FetchingInfoState();
    try {
      CurrentUser currentUser = await profileDetailsRepository.fetchUserInfo();
      yield FetchedInfoState(currentUser: currentUser);
    } catch (e) {
      yield FailedFetchInfoState();
    }
  }

  Stream<ProfiledetailsState> _mapFetchLocationInfotoState(
      FetchLocationInfoEvent event) async* {
    yield FetchingInfoState();
    try {
      String? locationInfo = await profileDetailsRepository.fetchLocationInfo();
      yield FetchedLocationInfo(locationInfo: locationInfo);
    } catch (e) {
      yield FailedFetchInfoState();
    }
  }

  Stream<ProfiledetailsState> _mapUpdateInfotoState(
      UpdateInfoEvent event) async* {
    yield UpdatingInfoState();
    try {
       await profileDetailsRepository.updateUserInfo(event.user);
      yield  UpdatedInfoState();
    } catch (e) {
      yield FailedtoUpdateInfoState();
    }
  }

}
