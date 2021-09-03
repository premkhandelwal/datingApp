part of 'firebaseauth_bloc.dart';

@immutable
abstract class FirebaseauthEvent {}

class UserStateRequested extends FirebaseauthEvent {}

class PhoneVerficationRequested extends FirebaseauthEvent {}

class SignUpRequested extends FirebaseauthEvent {
  final String emailId;
  final String password;

  SignUpRequested({required this.emailId, required this.password});
}

class SignInWithEmailPasswordRequested extends FirebaseauthEvent {
  final String emailId;
  final String password;

  SignInWithEmailPasswordRequested(
      {required this.emailId, required this.password});
}

class SignInWithPhoneNumberRequested extends FirebaseauthEvent {
  final String phoneNumber;

  SignInWithPhoneNumberRequested({required this.phoneNumber});
}

class OtpSendRequested extends FirebaseauthEvent {
  final PhoneCodeSent codeSent;
  final PhoneVerificationFailed phoneVerificationFailed;
  final String phoneNumber;
  OtpSendRequested({
    required this.codeSent,
    required this.phoneVerificationFailed,
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

class SignOutRequested extends FirebaseauthEvent {}
