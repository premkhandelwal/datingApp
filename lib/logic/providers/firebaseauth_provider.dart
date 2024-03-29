import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/const/shared_objects.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

abstract class BaseAuthProvider {
  Future<String?> getCurrentUserUID();
  Future<CurrentUser> signUpWithEmailPassword(String emailId, String password);
  Future<CurrentUser?> signInWithEmailPassword(String emailId, String password);
  Future<void> signOut();
  Future<AuthCredential?> verifyOTP(String smsCode, String verificationId);
  Future<void> sendOTP(
      String phoneNumber,
      PhoneCodeSent codeSent,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
      [int? resendToken]);
  Future<bool> linkEmailWithPhoneNumber(String emailId, String password);
  Future<bool> linkPhoneNumberWithEmail(String smsCode, String verificationId);
  Future<bool> sendverificationEmail();
  Future<bool> isEmailVerified();
  Future<bool> isdatalessUserDocExists(String uid);
  Future<bool> phoneEmailLinked(String uid);
}

class FirebaseAuthProvider extends BaseAuthProvider with ChangeNotifier {
  CollectionReference<Map<String, dynamic>> datalessCollection =
      FirebaseFirestore.instance.collection("DataLessUsers");
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("UserActivity");

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth get getInstance => _firebaseAuth;

  @override
  Future<String?> getCurrentUserUID() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();

      if (_firebaseAuth.currentUser?.uid != null) {
        collection
            .doc(_firebaseAuth.currentUser!.uid)
            .update({"lastLogin": DateTime.now()});//Log the last user login time in the database
      }
      return _firebaseAuth.currentUser?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        return null;
      }
    }
  }

  @override
  Future<bool> isdatalessUserDocExists(String uid) async {
    // If user hasn't entered his/her profile details like name, profession, birthdate, etc, DataLessUsers document will exist in Firestore Database 
    DocumentSnapshot<Map<String, dynamic>> doc =
        await datalessCollection.doc(uid).get() ;

    if (doc.exists) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> phoneEmailLinked(String uid) async {
    // Check the value of linkedEmailPhone variable, which is present in the DataLessUser collection  
    DocumentSnapshot<Map<String, dynamic>> doc =
        await datalessCollection.doc(uid).get();

    if (doc.data() != null) {
      if (doc.data()!["linkedEmailPhone"]) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<bool> iscollectionDocExists(String? uid) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await collection.doc("$uid").get();

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
          bool docExists = await iscollectionDocExists(userCredential.user?.uid) ;
      if (docExists) {
        
        collection
            .doc(userCredential.user!.uid)
            .update({"lastLogin": DateTime.now()});
      }

      return CurrentUser(firebaseUser: userCredential.user);
    } on FirebaseAuthException catch (error) {
      throw Exception(error.message);
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
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: emailId, password: password);
      await datalessCollection.doc(credential.user!.uid).set(
        {"timeStamp": DateTime.now(), "linkedEmailPhone": false},
      );
      return CurrentUser(firebaseUser: credential.user);
    } on FirebaseAuthException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<bool> linkEmailWithPhoneNumber(String emailId, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: emailId, password: password);
      UserCredential? userCredential =
          await _firebaseAuth.currentUser?.linkWithCredential(credential);
      if (userCredential != null) {
        await datalessCollection.doc(userCredential.user!.uid).update(
          {"linkedEmailPhone": true},
        );
      }
      return userCredential != null;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<bool> linkPhoneNumberWithEmail(
      String smsCode, String verificationId) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential? userCredential =
          await _firebaseAuth.currentUser?.linkWithCredential(credential);
      if (userCredential != null) {
        await datalessCollection
            .doc(userCredential.user!.uid)
            .update({"linkedEmailPhone": true});
      }
      return userCredential != null;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AuthCredential?> verifyOTP(
      String smsCode, String verificationId) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode:
            smsCode); // Creates a credential by taking verificationId and smsCode recieved via OTP
    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    collection.doc(result.user!.uid).update({"lastLogin": DateTime.now()});

    if (result.user != null) {
      bool docExist = await iscollectionDocExists(result.user!.uid);
      if (!docExist) {
        await datalessCollection
            .doc(result.user!.uid)
            .set({"timeStamp": DateTime.now()});
      }

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
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout, [int? resendToken]) async {
    try {
      _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted: (auth) {},
          verificationFailed: verificationFailed,
          forceResendingToken: resendToken,// Will be not null, only when resend OTP is requested by the user
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      throw Exception(e);
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
