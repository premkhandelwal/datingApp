import 'dart:async';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthProvider {
  String? getCurrentUserUID();
  Future<CurrentUser> signUpWithEmailPassword(String emailId, String password);
  Future<CurrentUser?> signInWithEmailPassword(String emailId, String password);
  //Future<String> signUpWithPhoneNumber(String phoneNumber);
  // Future<String> signInWithPhoneNumber(String phoneNumber);
  Future<void> signOut();
  Future<AuthCredential?> verifyOTP(String smsCode, String verificationId);
  Future<void> sendOTP(
      String phoneNumber,
      PhoneCodeSent codeSent,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout);
  Future<bool> linkEmailWithPhoneNumber(String emailId, String password);
  Future<bool> linkPhoneNumberWithEmail(String smsCode, String verificationId);
}

class FirebaseAuthProvider extends BaseAuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  String? getCurrentUserUID() {
    return _firebaseAuth.currentUser?.uid ;
  }

  @override
  Future<CurrentUser?> signInWithEmailPassword(
      String emailId, String password) async {
    try {
      UserCredential? userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: emailId, password: password);

      return CurrentUser(firebaseUser: userCredential.user);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  @override
  Future<CurrentUser> signUpWithEmailPassword(
      String emailId, String password) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: emailId, password: password);
    return CurrentUser(firebaseUser: credential.user);
  }

  @override
  Future<bool> linkEmailWithPhoneNumber(String emailId, String password) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: emailId, password: password);
    UserCredential? userCredential = await _firebaseAuth.currentUser?.linkWithCredential(credential);
    return userCredential != null;
  }

  @override
  Future<bool> linkPhoneNumberWithEmail(String smsCode,String verificationId) async {
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    UserCredential? userCredential = await _firebaseAuth.currentUser?.linkWithCredential(credential);
    return userCredential != null;
  }

  /* @override
  Future<String> signUpWithPhoneNumber(String phoneNumber) async {
    ConfirmationResult userCredential =
        await _firebaseAuth.signInWithPhoneNumber(phoneNumber);
    return userCredential.verificationId;
  } */

  @override
  Future<AuthCredential?> verifyOTP(
      String smsCode, String verificationId) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode:
            smsCode); // Creates a credential by taking verificationId and smsCode recieved via OTP
    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    if (result.user?.uid != null) {
      return credential;
    } //Pass the credential created, to the signInWithCredential()
    return null; // returns true if otp is verified else returns false
  }

  @override
  Future<void> sendOTP(
      String phoneNumber,
      PhoneCodeSent codeSent,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout) async {
    try {
      _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(seconds: 30),
          verificationCompleted: (auth) {},
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print("hello");
      print(e);
    }
  }
}
