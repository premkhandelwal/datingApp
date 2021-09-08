import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/repositories/firebaseAuthRepo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      yield* _mapSendOtpRequesttoState(event);
    } else if (event is OtpVerificationRequested) {
      yield* _mapVerifyOtpRequesttoState(event);
    } else if (event is OtpRetrievalTimeOut) {
      yield OtpRetrievalTimedOut();
    } else if (event is OtpRetrievalFailure) {
      yield OtpRetrievalFailed(errorMessage: event.errorMessage);
    }
  }

  Stream<FirebaseauthState> _mapUserStatetoState() async* {
    bool isSignedIn = firebaseAuthRepo.isSignedIn();
    if (isSignedIn) {
      yield UserLoggedIn();
    } else {
      yield UserLoggedOut();
    }
  }

  Stream<FirebaseauthState> _mapSignInWithEmailPasswordRequesttoState(
      SignInWithEmailPasswordRequested event) async* {
    yield OperationInProgress();

    CurrentUser? user = await firebaseAuthRepo.signInWithEmailPassword(
        event.emailId, event.password);
    if (user != null) {
      yield UserLoggedIn();
    } else {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSignUpWithEmailPasswordRequesttoState(
      SignUpWithEmailPasswordRequested event) async* {
    yield OperationInProgress();

    CurrentUser? user = await firebaseAuthRepo.signUpWithEmailPassword(
        event.emailId, event.password);
    if (user != null) {
      yield UserSignedUp();
    } else {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSignOutRequesttoState(
      SignOutRequested event) async* {
    try {
      yield OperationInProgress();

      await firebaseAuthRepo.signOut();
      yield UserLoggedOut();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSendOtpRequesttoState(
      OtpSendRequested event) async* {
    yield OperationInProgress();
    try {
      await firebaseAuthRepo.sendOTP(
        event.phoneNumber,
        event.codeSent,
        event.verificationFailed,
        event.codeAutoRetrievalTimeout
      );
      yield OtpSent();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapVerifyOtpRequesttoState(
      OtpVerificationRequested event) async* {
    try {
      yield OperationInProgress();

      bool otpVerified =
          await firebaseAuthRepo.verifyOTP(event.smsCode, event.verificationId);
      if (otpVerified) {
        yield OtpVerified();
      } else {
        yield OtpNotVerified();
      }
    } catch (e) {
      yield OtpNotVerified();
    }
  }
}
