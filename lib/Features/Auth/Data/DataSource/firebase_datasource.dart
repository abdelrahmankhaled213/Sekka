import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sekka/Core/App/env_variables.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/Auth/Data/Model/signup_request.dart';
import '../Model/signInRequest.dart';

class FirebaseDatasource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  late String verificationId;
  int? resendToken;

  FirebaseDatasource(this.firebaseAuth, this.googleSignIn);

  // ✅ Removed duplicate getCurrentUser() — reloadUser() covers this
  Future<void> reloadUser() async {
    await firebaseAuth.currentUser?.reload();
  }

  // ✅ Now returns UserCredential so cubit can extract uid immediately
  Future<UserCredential> signUp(SignUpRequest request) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: request.email,
      password: request.password,
    );
  }

  Future<void> sendEmailVerification() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  // ✅ Now returns UserCredential so cubit can extract uid immediately
  Future<UserCredential> signInWithEmail(SignInRequest signInRequest) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: signInRequest.email!,
      password: signInRequest.password,
    );
  }

  Future<void> signInWithPhone(String phone) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+2$phone",
      forceResendingToken: resendToken,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSentFunc,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeOut,
    );
  }

  Future<UserCredential> submitOtp(String otp) async {
    final PhoneAuthCredential phoneCred = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    return await _signIn(phoneCred);
  }

  // ✅ Fixed: now signs into Firebase and returns UserCredential
  Future<UserCredential> loginWithGoogle() async {
    await googleSignIn.initialize(
      clientId: EnvironmentVariable.instance.webClientId,
    );

    if (!googleSignIn.supportsAuthenticate()) {
      throw FirebaseAuthException(
        code: 'google-sign-in-unsupported',
        message: 'Google sign-in is not supported on this platform.',
      );
    }

    final GoogleSignInAccount? account = await googleSignIn.authenticate();

    if (account == null) {
      throw FirebaseAuthException(
        code: 'google-sign-in-cancelled',
        message: 'Google sign-in was cancelled by the user.',
      );
    }


    final GoogleSignInAuthentication googleAuth = await account.authentication;


    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await firebaseAuth.signInWithCredential(credential);
  }

  User? get user => firebaseAuth.currentUser;

  bool isAccountVerified() {
    return firebaseAuth.currentUser?.emailVerified ?? false;
  }

  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> _verificationCompleted(PhoneAuthCredential authCredential) async {
    await _signIn(authCredential);
  }

  void _verificationFailed(FirebaseAuthException error) {
    FlutterToastHelper.showToast(
      color: AppColor.error,
      text: ErrorHandler.handleError(error).message,
    );
  }

  void _codeSentFunc(String verificationId, int? forceSendingToken) {
    this.verificationId = verificationId;
    debugPrint('Verification ID: $verificationId');
  }

  void _codeAutoRetrievalTimeOut(String verificationId) {
    debugPrint('Code auto retrieval timeout');
  }

  Future<UserCredential> _signIn(AuthCredential cred) async {
    return await firebaseAuth.signInWithCredential(cred);
  }
}