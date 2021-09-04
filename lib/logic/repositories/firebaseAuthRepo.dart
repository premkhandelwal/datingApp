import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/firebaseAuthProvider.dart';
import 'package:dating_app/logic/repositories/baseRepo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository extends BaseRepository {
  FirebaseAuthProvider authprovider = FirebaseAuthProvider();
  bool isSignedIn() => authprovider.isSignedIn();
  Future<CurrentUser?> signInWithEmailPassword(
          String emailId, String password) =>
      authprovider.signInWithEmailPassword(emailId, password);
  Future<CurrentUser?> signUpWithEmailPassword(
          String emailId, String password) =>
      authprovider.signUpWithEmailPassword(emailId, password);
  /* Future<String?> signInWithPhoneNumber(String phoneNumber) =>
      authprovider.signInWithPhoneNumber(phoneNumber); */
  Future<void> signOut() => authprovider.signOut();
  Future<void> sendOTP(
          String phoneNumber,
          PhoneCodeSent codeSent,
          PhoneVerificationFailed verificationFailed,
          PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout) =>
      authprovider.sendOTP(phoneNumber, codeSent,verificationFailed,codeAutoRetrievalTimeout);
  Future<bool> verifyOTP(String smsCode, String verificationId) =>
      authprovider.verifyOTP(smsCode, verificationId);

  @override
  void dispose() {}
}
