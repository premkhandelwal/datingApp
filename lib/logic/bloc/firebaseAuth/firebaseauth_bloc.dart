import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/repositories/firebaseAuthRepo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'firebaseauth_event.dart';
part 'firebaseauth_state.dart';

class FirebaseauthBloc extends Bloc<FirebaseauthEvent, FirebaseauthState> {
  FirebaseauthBloc({required this.firebaseAuthRepo})
      : super(FirebaseauthInitial()) {
    subscription =
        firebaseAuthRepo.getInstance.authStateChanges().listen((user) async* {
      if (user == null) {
        yield UserLoggedOut();
      } else {
        yield UserLoggedIn(userUID: user.uid);
      }
    });
  }
  final FirebaseAuthRepository firebaseAuthRepo;
  StreamSubscription<User?>? subscription;

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

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
    } else if (state is UserLoggedOut) {
      
    }
  }

  Stream<FirebaseauthState> _mapUserStatetoState() async* {
    String? currentUserUID = firebaseAuthRepo.getCurrentUserUID();
    if (currentUserUID != null) {
      yield UserLoggedIn(userUID: currentUserUID);
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
      yield UserLoggedIn(userUID: user.firebaseUser!.uid);
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
      yield UserSignedUp(userUID: user.firebaseUser!.uid);
    } else {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSignOutRequesttoState(
      SignOutRequested event) async* {
    try {
      yield OperationInProgress();

      await firebaseAuthRepo.signOut();
      firebaseAuthRepo.getInstance.authStateChanges().listen((user) async* {
        if (user == null) {
          yield UserLoggedOut();
        } else {
          yield UserLoggedIn(userUID: user.uid);
        }
      });
      yield UserLoggedOut();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSendOtpRequesttoState(
      OtpSendRequested event) async* {
    try {
      await firebaseAuthRepo.sendOTP(event.phoneNumber, event.codeSent,
          event.verificationFailed, event.codeAutoRetrievalTimeout);
      yield OtpSent();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapVerifyOtpRequesttoState(
      OtpVerificationRequested event) async* {
    try {
      yield OperationInProgress();

      AuthCredential? authCredential =
          await firebaseAuthRepo.verifyOTP(event.smsCode, event.verificationId);
      if (authCredential != null) {
        String? uid = firebaseAuthRepo.getCurrentUserUID();
        yield OtpVerified(authCredential: authCredential, userUID: uid);
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
      } else {
        yield FailedtoLinkedPhoneNumberEmail();
      }
    } catch (e) {
      yield FailedtoLinkedPhoneNumberEmail();
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
      } else {
        yield FailedtoLinkedPhoneNumberEmail();
      }
    } catch (e) {
      yield FailedtoLinkedPhoneNumberEmail();
    }
  }
}
