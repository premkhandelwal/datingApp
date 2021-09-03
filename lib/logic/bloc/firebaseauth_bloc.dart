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
    if (event is UserStateRequested) {
      yield* _mapUserStatetoState();
    } else if (event is SignInWithEmailPasswordRequested) {
      yield* _mapSignInWithEmailPasswordRequesttoState(event);
    } else if (event is SignInWithPhoneNumberRequested) {
      yield* _mapSignInWithPhoneNumberRequesttoState(event);
    } else if (event is SignOutRequested) {
      yield* _mapSignOutRequesttoState(event);
    } else if (event is OtpSendRequested) {
      yield* _mapSendOtpRequesttoState(event);
    } else if (event is OtpVerificationRequested) {
      yield* _mapVerifyOtpRequesttoState(event);
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
    CurrentUser? user = await firebaseAuthRepo.signInWithEmailPassword(
        event.emailId, event.password);
    if (user != null) {
      yield UserLoggedIn();
    } else {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSignInWithPhoneNumberRequesttoState(
      SignInWithPhoneNumberRequested event) async* {
    
   
      String? _verificationId =
          await firebaseAuthRepo.signInWithPhoneNumber(event.phoneNumber);
      if (_verificationId != null) {
        yield PhoneNumberVerificationCompleted(verificationId: _verificationId);
      } else {
        yield RequesteImpledOperationFailed();
      }
    
  }

  Stream<FirebaseauthState> _mapSignOutRequesttoState(
      SignOutRequested event) async* {
    try {
      await firebaseAuthRepo.signOut();
      yield UserLoggedOut();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSendOtpRequesttoState(
      OtpSendRequested event) async* {
    try {
      await firebaseAuthRepo.sendOTP(
          event.phoneNumber, event.codeSent, event.phoneVerificationFailed);
      yield OtpSent();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapVerifyOtpRequesttoState(
      OtpVerificationRequested event) async* {
    try {
      bool otpVerified =
          await firebaseAuthRepo.verifyOTP(event.smsCode, event.verificationId);
      if (otpVerified) {
        yield OtpVerified();
      } else {
        yield OtpNotVerified();
      }
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }
}
