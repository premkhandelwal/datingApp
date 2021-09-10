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
    }
  }

  Stream<ProfiledetailsState> _mapAddBasicInfoEventtoState(
      AddBasicInfoEvent event) async* {
    try {
      yield AddingInfoState();
      // currentuser.firstName = event.user.firstName;
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
      await profileDetailsRepository.addGenderInfo(event.user);
      yield AddedGenderInfoState();
    } catch (e) {
      yield FailedtoAddInfoState();
    }
  }

  Stream<ProfiledetailsState> _mapAddInterestInfoEventtoState(
      AddInterestsInfoEvent event) async* {
    try {
      yield AddingInfoState();
      await profileDetailsRepository.addInterestInfo(event.user);
      yield AddedInterestsInfoState();
    } catch (e) {
      yield FailedtoAddInfoState();
    }
  }
}
