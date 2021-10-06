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
  ProfiledetailsBloc({required this.profileDetailsRepository})
      : super((ProfiledetailsInitial()));

  @override
  Stream<ProfiledetailsState> mapEventToState(
    ProfiledetailsEvent event,
  ) async* {
    if (event is AddBasicInfoEvent) {
      yield* _mapAddBasicInfoEventtoState(event);
    } else if (event is AddGenderInfoEvent) {
      yield* _mapAddGenderInfoEventtoState(event);
    } else if (event is AddInterestedInInfoEvent) {
      yield* _mapAddInterestedInInfoEventtoState(event);
    } else if (event is AddInterestsInfoEvent) {
      yield* _mapAddInterestInfoEventtoState(event);
    } else if (event is SubmitInfoEvent) {
      yield* _mapSubmitInfoEventtoState(event);
    } else if (event is UpdateInfoEvent) {
      yield* _mapUpdateInfotoState(event);
    } else if (event is DataLoadingInProgress) {
      yield DataLoadingInProgressState();
    } else if (event is ShowMore) {
      yield* _mapShowMoretoState(event);
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
      currentUser.image = event.user.image;
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

  Stream<ProfiledetailsState> _mapAddInterestedInInfoEventtoState(
      AddInterestedInInfoEvent event) async* {
    try {
      yield AddingInfoState();
      currentUser.interestedin = event.user.interestedin;
      // await profileDetailsRepository.addGenderInfo(event.user);
      yield AddedInterestedInInfoState();
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

  Stream<ProfiledetailsState> _mapUpdateInfotoState(
      UpdateInfoEvent event) async* {
    yield UpdatingInfoState();
    try {
      await profileDetailsRepository.updateUserInfo(event.user);
      yield UpdatedInfoState(currentUser: event.user);
    } catch (e) {
      yield FailedtoUpdateInfoState();
    }
  }

  Stream<ProfiledetailsState> _mapShowMoretoState(ShowMore event) async* {
    yield ShowMoreState(isBio: event.isBio,isInterests: event.isInterests);
  }
}
