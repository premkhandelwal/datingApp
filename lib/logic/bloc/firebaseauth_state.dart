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

class OtpSent extends FirebaseauthState{}

class OtpVerified extends FirebaseauthState{}

class OtpNotVerified extends FirebaseauthState{}


class RequestedOperationFailed extends FirebaseauthState{}

class UserLoggedIn extends FirebaseauthState {
  /* final CurrentUser? currentUser;

  UserLoggedIn({this.currentUser}); */
}

class UserLoggingIn extends FirebaseauthState {}

class UserLoggedOut extends FirebaseauthState {}

class UserSignedUp extends FirebaseauthState {
  final CurrentUser? currentUser;

  UserSignedUp({this.currentUser});
}
