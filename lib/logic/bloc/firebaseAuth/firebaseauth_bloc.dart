import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/repositories/firebase_auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'firebaseauth_event.dart';
part 'firebaseauth_state.dart';

class FirebaseauthBloc extends Bloc<FirebaseauthEvent, FirebaseauthState> {
  FirebaseauthBloc({required this.firebaseAuthRepo})
      : super(FirebaseauthInitial());
  final FirebaseAuthRepository firebaseAuthRepo;

  @override
  Stream<FirebaseauthState> mapEventToState(
    FirebaseauthEvent event,
  ) async* {
    if (event is UserStateNone) {
      yield FirebaseauthInitial();
    } else if (event is UserStateRequested) {
      yield* _mapUserStatetoState();
    } else if (event is SignInWithEmailPasswordRequested) {
      yield* _mapSignInWithEmailPasswordRequesttoState(event);
    } else if (event is SignUpWithEmailPasswordRequested) {
      yield* _mapSignUpWithEmailPasswordRequesttoState(event);
    } else if (event is SignOutRequested) {
      yield* _mapSignOutRequesttoState(event);
    } else if (event is OtpSendRequested) {
      yield OperationInProgress();
      yield* _mapSendOtpRequesttoState(event);
    } else if (event is OtpVerificationRequested) {
      yield* _mapVerifyOtpRequesttoState(event);
    } else if (event is OtpRetrievalTimeOut) {
      yield OtpRetrievalTimedOut();
    } else if (event is OtpRetrievalFailure) {
      yield OtpRetrievalFailed(errorMessage: event.errorMessage);
    } else if (event is LinkEmailWithPhoneNumberEvent) {
      yield* _maplinkEmailwithPhoneeventtoState(event);
    } else if (event is LinkPhoneNumberWithEmailEvent) {
      yield* _maplinkPhonewithEmaileventtoState(event);
    } else if (event is EmailVerificationRequested) {
      yield* __mapEmailVerificationRequested();
    } else if (event is EmailVerificationStateRequested) {
      yield* __mapEmailVerificationStateRequested();
    } else if (event is SignedInforFirstTimeEvent) {
      yield* __mapSignedInFirstTimeState(event);
    } else if (event is LinkStatusEvent) {
      yield* __mapLinkStatusEventtoState(event);
    }
  }

  Stream<FirebaseauthState> _mapUserStatetoState() async* {
    try {
      String? currentUserUID = await firebaseAuthRepo.getCurrentUserUID();
      if (currentUserUID != null) {
        yield UserLoggedIn(userUID: currentUserUID);
      } else {
        yield UserLoggedOut();
      }
    } catch (e) {
      yield UserLoggedOut();
    }
  }

  Stream<FirebaseauthState> _mapSignInWithEmailPasswordRequesttoState(
      SignInWithEmailPasswordRequested event) async* {
    yield OperationInProgress();
    try {
      CurrentUser? user = await firebaseAuthRepo.signInWithEmailPassword(
          event.emailId, event.password);
      if (user != null) {
        yield UserLoggedIn(userUID: user.firebaseUser!.uid);
      }
    } catch (e) {
      yield RequestedOperationFailed(errorMessage: e);
    }
  }

  Stream<FirebaseauthState> _mapSignUpWithEmailPasswordRequesttoState(
      SignUpWithEmailPasswordRequested event) async* {
    yield OperationInProgress();
    try {
      CurrentUser? user = await firebaseAuthRepo.signUpWithEmailPassword(
          event.emailId, event.password);
      if (user != null) {
        yield UserSignedUp(userUID: user.firebaseUser!.uid);
      }
    } catch (e) {
      yield RequestedOperationFailed(errorMessage: e);
    }
  }

  Stream<FirebaseauthState> _mapSignOutRequesttoState(
      SignOutRequested event) async* {
    try {
      yield OperationInProgress();

      await firebaseAuthRepo.signOut();
      yield UserLoggedOut();
    } catch (e) {
      yield RequestedOperationFailed(errorMessage: e);
    }
  }

  Stream<FirebaseauthState> _mapSendOtpRequesttoState(
      OtpSendRequested event) async* {
    try {
      await firebaseAuthRepo.sendOTP(
          event.phoneNumber,
          event.codeSent,
          event.verificationFailed,
          event.codeAutoRetrievalTimeout,
          event.resendToken);
      yield OtpSent();
    } on Exception catch (e) {
      yield RequestedOperationFailed(errorMessage: e);
    }
  }

  Stream<FirebaseauthState> _mapVerifyOtpRequesttoState(
      OtpVerificationRequested event) async* {
    try {
      yield OperationInProgress();

      AuthCredential? authCredential =
          await firebaseAuthRepo.verifyOTP(event.smsCode, event.verificationId);
      if (authCredential != null) {
        String? uid = await firebaseAuthRepo.getCurrentUserUID();
        yield OtpVerified(authCredential: authCredential, userUID: uid);
        SharedObjects.prefs?.setString(SessionConstants.sessionUid, uid!);
        add(SignedInforFirstTimeEvent(uid: uid!));
      } else {
        yield OtpNotVerified();
      }
    } catch (e) {
      yield OtpNotVerified();
    }
  }

  Stream<FirebaseauthState> _maplinkEmailwithPhoneeventtoState(
      LinkEmailWithPhoneNumberEvent event) async* {
    yield OperationInProgress();
    try {
      bool linkedPhoneNumberEmail = await firebaseAuthRepo
          .linkEmailWithPhoneNumber(event.emailId, event.password);
      if (linkedPhoneNumberEmail) {
        yield LinkedEmailWithPhoneNumber();
      }
    } catch (e) {
      yield FailedtoLinkedPhoneNumberEmail(errorMessage: e);
    }
  }

  Stream<FirebaseauthState> _maplinkPhonewithEmaileventtoState(
      LinkPhoneNumberWithEmailEvent event) async* {
    yield OperationInProgress();

    try {
      bool linkedPhoneNumberEmail = await firebaseAuthRepo
          .linkPhoneNumberWithEmail(event.smsCode, event.verificationId);
      if (linkedPhoneNumberEmail) {
        yield LinkedPhoneNumberWithEmail();
      }
    } catch (e) {
      yield FailedtoLinkedPhoneNumberEmail(errorMessage: e);
    }
  }

  Stream<FirebaseauthState> __mapEmailVerificationRequested() async* {
    try {
      bool verificationSent = await firebaseAuthRepo.sendverificationEmail();
      if (verificationSent) {
        yield EmailVerificationSentState();
      } else {
        yield FailedtoSendEmailVerificationState();
      }
    } catch (e) {
      yield FailedtoSendEmailVerificationState();
    }
  }

  Stream<FirebaseauthState> __mapEmailVerificationStateRequested() async* {
    try {
      bool isEmailVerified = await firebaseAuthRepo.isEmailVerified();
      if (isEmailVerified) {
        yield EmailVerifiedState();
      } else {
        yield EmailNotVerifiedState();
      }
    } catch (e) {
      yield EmailNotVerifiedState();
    }
  }

  Stream<FirebaseauthState> __mapSignedInFirstTimeState(
      SignedInforFirstTimeEvent event) async* {
    try {
      bool isuserDocExists = await firebaseAuthRepo.isuserDocExists(event.uid);
      if (isuserDocExists) {
        yield SignedInForFirstTimeState();
        add(EmailVerificationStateRequested());
      } else {
        yield NotSignedInForFirstTimeState(userUID: event.uid);
      }
    } catch (e) {
      yield FailedtogetSignInForFirstTimeState();
    }
  }

  Stream<FirebaseauthState> __mapLinkStatusEventtoState(
      LinkStatusEvent event) async* {
    bool islinked = await firebaseAuthRepo.phoneEmailLinked(event.uid);
    if (islinked) {
      yield PhoneEmailLinkedState();
    } else {
      yield PhoneEmailNotLinkedState();
    }
  }
}
