part of 'firebaseauth_bloc.dart';

@immutable
abstract class FirebaseauthEvent {}

class UserStateNone extends FirebaseauthEvent {}

class UserStateRequested extends FirebaseauthEvent {}

class PhoneVerficationRequested extends FirebaseauthEvent {}

class SignUpWithEmailPasswordRequested extends FirebaseauthEvent {
  final String emailId;
  final String password;

  SignUpWithEmailPasswordRequested(
      {required this.emailId, required this.password});
}

class SignInWithEmailPasswordRequested extends FirebaseauthEvent {
  final String emailId;
  final String password;

  SignInWithEmailPasswordRequested(
      {required this.emailId, required this.password});
}

class OtpSendRequested extends FirebaseauthEvent {
  final PhoneCodeSent codeSent;
  final PhoneVerificationFailed verificationFailed;
  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout;
  final String phoneNumber;

  OtpSendRequested({
    required this.codeSent,
    required this.verificationFailed,
    required this.codeAutoRetrievalTimeout,
    required this.phoneNumber,
  });
}

class OtpVerificationRequested extends FirebaseauthEvent {
  final String smsCode;
  final String verificationId;
  OtpVerificationRequested({
    required this.smsCode,
    required this.verificationId,
  });
}

class OtpRetrievalTimeOut extends FirebaseauthEvent {}

class OtpRetrievalFailure extends FirebaseauthEvent {
  final String errorMessage;
  OtpRetrievalFailure({
    required this.errorMessage,
  });
}

class LinkEmailWithPhoneNumberEvent extends FirebaseauthEvent {
  final String emailId;
  final String password;
  LinkEmailWithPhoneNumberEvent({
    required this.emailId,
    required this.password,
  });
}

class LinkPhoneNumberWithEmailEvent extends FirebaseauthEvent {
  final String smsCode;
  final String verificationId;
  LinkPhoneNumberWithEmailEvent({
    required this.smsCode,
    required this.verificationId,
  });
}

class SignOutRequested extends FirebaseauthEvent {}

class EmailVerificationRequested extends FirebaseauthEvent {}

class EmailVerificationStateRequested extends FirebaseauthEvent {}

class SignedInforFirstTimeEvent extends FirebaseauthEvent {
  final String uid;
  SignedInforFirstTimeEvent({
    required this.uid,
  });
}

class LinkStatusEvent extends FirebaseauthEvent{
  final String uid;
  LinkStatusEvent({
    required this.uid,
  });
}
