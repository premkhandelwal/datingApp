import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/firebaseauth_provider.dart';
import 'package:dating_app/logic/repositories/base_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository extends BaseRepository {
  FirebaseAuthProvider authprovider = FirebaseAuthProvider();
  FirebaseAuth get getInstance => authprovider.getInstance;
  Future<String?> getCurrentUserUID() async =>  await authprovider.getCurrentUserUID();
  Future<CurrentUser?> signInWithEmailPassword(
          String emailId, String password) =>
      authprovider.signInWithEmailPassword(emailId, password);
  Future<CurrentUser?> signUpWithEmailPassword(
          String emailId, String password) =>
      authprovider.signUpWithEmailPassword(emailId, password);
  Future<void> signOut() => authprovider.signOut();
  Future<void> sendOTP(
          String phoneNumber,
          PhoneCodeSent codeSent,
          PhoneVerificationFailed verificationFailed,
          PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
          [int? resendToken]) =>
      authprovider.sendOTP(
          phoneNumber, codeSent, verificationFailed, codeAutoRetrievalTimeout,resendToken);
  Future<AuthCredential?> verifyOTP(String smsCode, String verificationId) =>
      authprovider.verifyOTP(smsCode, verificationId);
  Future<bool> linkEmailWithPhoneNumber(String emailId, String password) async => await authprovider.linkEmailWithPhoneNumber(emailId, password);
  Future<bool> linkPhoneNumberWithEmail(String smsCode, String verificationId) async => await authprovider.linkPhoneNumberWithEmail(smsCode,verificationId);
  Future<bool> sendverificationEmail() async =>await authprovider.sendverificationEmail();
  Future<bool> isEmailVerified() async =>await authprovider.isEmailVerified();
  Future<bool> isuserDocExists(String uid) async=>await authprovider.isdatalessUserDocExists(uid);
  Future<bool> phoneEmailLinked(String uid) => authprovider.phoneEmailLinked(uid);

  @override
  void dispose() {}
}
