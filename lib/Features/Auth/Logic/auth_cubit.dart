import 'package:bloc/bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Features/Auth/Data/Model/signup_request.dart';
import 'package:sekka/Features/Auth/Data/UseCase/get_profile_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/google_sign_in_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/handle_verfication_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/resend_email_verification.dart';
import 'package:sekka/Features/Auth/Data/UseCase/reset_password_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/signup_usecase.dart';
import '../Data/Model/signInRequest.dart';
import '../Data/UseCase/signIn_usecase.dart';
import '../Data/UseCase/submit_otp.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  final LoginUseCase loginUseCase;
  final SubmitOtpUseCase submitOtpUseCase;
  final SignUpUseCase signupUseCase;
  final HandleVerificationUsecase handleVerificationUsecase;
  final GoogleSignInUseCase googleSignInUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final ResendEmailVerification resendEmailVerification;
  final GetProfileUsecase getProfileUsecase;
   String? signUpEmail;
   String? signUpPassword;
   String? signUpConfirmPassword;

  AuthCubit({
    required this.getProfileUsecase,
    required this.resendEmailVerification,
    required this.resetPasswordUseCase,
    required this.googleSignInUseCase,
    required this.handleVerificationUsecase,
    required this.signupUseCase,
    required this.submitOtpUseCase,
    required this.loginUseCase
})
      : super(AuthSigninState());

  void clearData(){
    signUpEmail=null;
    signUpPassword=null;
    signUpConfirmPassword=null;
  }




  void navigateToVerifyEmail({required String email,required bool isBackToLogin})=>emit(AuthVerificationState(
  email: email,
  backToLogin: isBackToLogin
));

  

  void navigateToSignUp()=> emit(AuthSignupState());

  void navigateToSignIn()=> emit(AuthSigninState());

  void navigateToForgotPassword()=>  emit(AuthForgotPasswordState());
  
  void navigateToOtpState(String phone)=>emit(AuthOtpState(phone));
  
Future<void> loginWithGoogle() async {
  await _execute(
    action: () => googleSignInUseCase(),
    loading: GoogleLoading(),
    success: GoogleLoaded(),
    failure: (msg) => GoogleError(msg),
  );
}

Future<void> login(SignInRequest request) async {
  await _execute(
    action: () => loginUseCase(request),
    loading: LoginLoading(),
    success: LoginSuccess(),
    failure: (msg) => LoginFailure(msg),
  );
}

 Future<void> signup(SignUpRequest request) async {
  await _execute(
    action: () => signupUseCase(request),
    loading: SignUpLoading(),
    success: SignUpLoaded(),
    failure: (msg) => SignUpError(msg),
  );
}

Future<void> submitOtp(String otp, String phone) async {
  await _execute(
    action: () => submitOtpUseCase(otp, phone),
    loading: OtpLoading(),
    success: OtpSuccess(),
    failure: (msg) => OtpFailure(msg),
  );
}

Future<void>isVerifiedUser()async{

    emit(VerifyUserLoading());
 try{

if(isClosed) return;

   final isVerified= await handleVerificationUsecase();

  if(isVerified) {
  emit(VerifyUserSuccess(
      isVerified: true
  ));

}else{
  emit(VerifyUserSuccess(
    isVerified: false
  ));

}

 }catch(e){

   _handleError(e, StackTrace.current, (msg) => VerifyUserFailed(msg));
 
 }

  }


Future<void> getProfile() async{

  try{

    if(isClosed)return;
   
   final user= await getProfileUsecase();
 
 if(user==null) return;

   final isGetStarted=user.isGetStarted; 

    emit(GetProfileSuccess(
isGetStarted??false
    ));

  }catch(e){
    _handleError(e, StackTrace.current, (msg) => GetProfileError(msg));
  }
  
}



Future<void> resendEmail() async {
  try {
    await resendEmailVerification();
    emit(ResendEmailSuccess());
  } catch (e, s) {
    _handleError(e, s, (msg) => ResendEmailFailiure(msg));
  }
}
Future<void> resetPassword(String email) async {
  await _execute(
    action: () => resetPasswordUseCase(email),
    loading: ResetPasswordLoading(),
    success: ResetPasswordSuccess(),
    failure: (msg) => ResetPasswordFailure(msg),
  );
}

Future<void> _execute({
  required Future<void> Function() action,
  required AuthState loading,
  required AuthState success,
  required AuthState Function(String) failure,
}) async {

  if (isClosed) return;

  emit(loading);

  try {
    await action();
    if (!isClosed) emit(success);
  } catch (e, s) {
    _handleError(e, s, failure);
  }
}
void _handleError(
  Object e,
  StackTrace s,
  AuthState Function(String) failure,
) {
  print(e.toString());
  print(s.toString());
  final error = ErrorHandler.handleError(e);
  emit(failure(error.message));
}
}
