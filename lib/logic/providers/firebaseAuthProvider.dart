import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

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
  Future<bool> sendverificationEmail();
  Future<bool> isEmailVerified();
  Future<bool> isuserDocExists(String uid);
}

class FirebaseAuthProvider extends BaseAuthProvider with ChangeNotifier {
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("DataLessUsers");

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth get getInstance => _firebaseAuth;

  @override
  String? getCurrentUserUID() {
    return _firebaseAuth.currentUser?.uid;
  }

  StreamSubscription<User?> onAuthStateChanged() {
    return _firebaseAuth.authStateChanges().listen((event) {
      print(event);
    });
  }

  @override
  Future<bool> isuserDocExists(String uid) async {
   
    DocumentSnapshot<Map<String, dynamic>> doc = await collection
        .doc("$uid")
        .get();

    if (doc.exists) {
      return true;
    }
    return false;
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
    SharedObjects.prefs?.clearSession();
    SharedObjects.prefs?.clearAll();
    Directory tempDir = await getTemporaryDirectory();
    tempDir.deleteSync(recursive: true);
    _firebaseAuth.signOut();
    notifyListeners();
  }

  @override
  Future<CurrentUser> signUpWithEmailPassword(
      String emailId, String password) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: emailId, password: password);
    await collection.doc(credential.user!.uid).set({});
    return CurrentUser(firebaseUser: credential.user);
  }

  @override
  Future<bool> linkEmailWithPhoneNumber(String emailId, String password) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: emailId, password: password);
    UserCredential? userCredential =
        await _firebaseAuth.currentUser?.linkWithCredential(credential);
    return userCredential != null;
  }

  @override
  Future<bool> linkPhoneNumberWithEmail(
      String smsCode, String verificationId) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    UserCredential? userCredential =
        await _firebaseAuth.currentUser?.linkWithCredential(credential);
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
  Future<bool> sendverificationEmail() async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.currentUser?.sendEmailVerification();

      return true;
    }
    return false;
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

  @override
  Future<bool> isEmailVerified() async {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.emailVerified;
    }
    return false;
  }
}
