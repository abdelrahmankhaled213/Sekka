
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable{
const AuthState();
  @override
  List<Object?> get props => [];
}

final class GetProfileSuccess extends AuthState {
  final bool isGettingStarted;
  const GetProfileSuccess(this.isGettingStarted);
  @override
  List<Object?> get props => [isGettingStarted];
}

final class GetProfileError extends AuthState {
  final String errorMsg;
  const GetProfileError(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}

final class AuthInitial extends AuthState {}

final class AuthSigninState extends AuthState {}

final class AuthSignupState extends AuthState {}

final class AuthOtpState extends AuthState {
  final String phone;
  const AuthOtpState(this.phone);
  @override
  List<Object?> get props => [phone];
}
final class AuthVerificationState extends AuthState {
  final String email;
  final bool backToLogin;
  const AuthVerificationState({
    required this.email,
    required this.backToLogin
});
  @override
  List<Object?> get props => [email, backToLogin];
}


final class AuthForgotPasswordState extends AuthState{}


final class LoginInitial extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {

}

final class LoginFailure extends AuthState {
  final String errorMsg;
  const LoginFailure(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}
final class ResetPasswordLoading extends AuthState {}

final class ResetPasswordSuccess extends AuthState {

}

final class ResetPasswordFailure extends AuthState {
  final String errorMsg;
  const ResetPasswordFailure(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}


final class OtpLoading extends AuthState {}

final class OtpSuccess extends AuthState {


const OtpSuccess();

}

final class OtpFailure extends AuthState {
  final String errorMsg;
  const OtpFailure(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}

final class GoogleLoading extends AuthState{

}
final class GoogleLoaded extends AuthState{

}
final class GoogleError extends AuthState {
  final String errorMsg;
  const GoogleError(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}

final class SignUpLoading extends AuthState {}

final class SignUpLoaded extends AuthState {

}

final class SignUpError extends AuthState {

  final String errorMsg;
  const SignUpError(this.errorMsg);

   @override
  List<Object?> get props => [errorMsg];

}

final class VerifyUserLoading extends AuthState{

}

final class VerifyUserSuccess extends AuthState {
  final bool isVerified;
  const VerifyUserSuccess({
    this.isVerified = false
  });
  @override
  List<Object?> get props => [isVerified];
}
final class VerifyUserFailed extends AuthState {
  final String errorMsg;
  const VerifyUserFailed(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}

final class ResendEmailSuccess extends AuthState{
  const ResendEmailSuccess();
}

final class ResendEmailFailiure extends AuthState {
  final String errorMsg;
  const ResendEmailFailiure(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}


