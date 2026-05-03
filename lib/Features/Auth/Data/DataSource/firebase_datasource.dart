import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sekka/Core/App/env_variables.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/Auth/Data/Model/signup_request.dart';
import '../Model/signInRequest.dart';

class FirebaseDatasource  {

  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  late String verificationId;
  int? resendToken;

  FirebaseDatasource(this.firebaseAuth,this.googleSignIn);


Future<void>getCurrentUser()async{

  await firebaseAuth.currentUser?.reload();
  
  }


  Future<void> signUp(SignUpRequest request) async {

     await firebaseAuth.createUserWithEmailAndPassword(
      email: request.email,
      password: request.password,
     );
  }

  Future<void>sendEmailVerification()async{
    final user=firebaseAuth.currentUser;
    if(user!=null) {
     await firebaseAuth.currentUser?.sendEmailVerification();
    }
    }
  Future<void>signInWithEmail
      (SignInRequest signInRequest) async
  {
      await firebaseAuth
          .signInWithEmailAndPassword(email: signInRequest.email!
          , password: signInRequest.password);
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


  Future<UserCredential>submitOtp(String otp)async{

    final PhoneAuthCredential phoneCred=PhoneAuthProvider
        .credential(verificationId: verificationId, smsCode: otp);
    final cred= await _signIn(phoneCred);

    return cred;


  }


  Future<GoogleSignInAccount?> loginWithGoogle() async {
    
    await googleSignIn.initialize(
      clientId: EnvironmentVariable.instance.webClientId

    );
    if(googleSignIn.supportsAuthenticate()){
      final account=await googleSignIn.authenticate();
      return account;
    }
return null;

  }

  Future<void>reloadUser()async{

    await firebaseAuth.currentUser?.reload();

  }

  User? get user =>firebaseAuth.currentUser;

  bool isAccountVerified() {

    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }




  Future<void> _verificationCompleted(PhoneAuthCredential authCredential)
  async {
    await _signIn(authCredential);
  }
  void _verificationFailed(FirebaseAuthException error){

FlutterToastHelper.showToast(color: AppColor.error,text: ErrorHandler.handleError(error).message);

  }

  void _codeSentFunc(String verificationId,int? forceSendingToken)  {

    this.verificationId=verificationId;
print(verificationId);

  }
  void _codeAutoRetrievalTimeOut(String verificationId){
    print("timeout");
  }

  Future<UserCredential> _signIn(PhoneAuthCredential cred)async{
  final phoneCred=  await firebaseAuth.signInWithCredential(cred);
return phoneCred;
  }

Future<void>resetPassword(String email) async {
  await FirebaseAuth.instance
      .sendPasswordResetEmail(email: email);
}
}