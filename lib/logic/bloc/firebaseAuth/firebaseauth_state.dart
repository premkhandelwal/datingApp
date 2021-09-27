part of 'firebaseauth_bloc.dart';

@immutable
abstract class FirebaseauthState {}

class FirebaseauthInitial extends FirebaseauthState {}

class PhoneNumberVerificationCompleted extends FirebaseauthState {
  final String verificationId;
  PhoneNumberVerificationCompleted({
    required this.verificationId,
  });
}

class OperationInProgress extends FirebaseauthState {}

class OtpSent extends FirebaseauthState {}

class OtpVerified extends FirebaseauthState {
  final AuthCredential authCredential;
  final String? userUID;
  OtpVerified({
    required this.authCredential,
    this.userUID
  });
}

class OtpNotVerified extends FirebaseauthState {}

class OtpRetrievalTimedOut extends FirebaseauthState {}

class OtpRetrievalFailed extends FirebaseauthState {
  final String errorMessage;
  OtpRetrievalFailed({
    required this.errorMessage,
  });
}

class RequestedOperationFailed extends FirebaseauthState {}

class UserLoggedIn extends FirebaseauthState {
  final String userUID;
  UserLoggedIn({
    required this.userUID,
  });
}

class UserLoggingIn extends FirebaseauthState {}

class UserLoggedOut extends FirebaseauthState {}

class UserSignedUp extends FirebaseauthState {
  final String userUID;
  UserSignedUp({
    required this.userUID,
  });
}

class EmailVerificationSentState extends FirebaseauthState{} 

class FailedtoSendEmailVerificationState extends FirebaseauthState{} 

class EmailVerifiedState extends FirebaseauthState{} 

class EmailNotVerifiedState extends FirebaseauthState{} 

class LinkedEmailWithPhoneNumber extends FirebaseauthState {}

class LinkedPhoneNumberWithEmail extends FirebaseauthState {}

class FailedtoLinkedPhoneNumberEmail extends FirebaseauthState {}

class SignedInForFirstTimeState extends FirebaseauthState{}

class NotSignedInForFirstTimeState extends FirebaseauthState{}
class FailedtogetSignInForFirstTimeState extends FirebaseauthState{}
