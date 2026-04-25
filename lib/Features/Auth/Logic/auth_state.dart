
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable{
const AuthState();
  @override
  List<Object?> get props => [];
}

final class GetProfileSuccess extends AuthState {

  final bool isGettingStarted;

  const GetProfileSuccess(this.isGettingStarted);

}

final class GetProfileError extends AuthState {
  final String errorMsg;
  const GetProfileError(this.errorMsg);
}

final class AuthInitial extends AuthState {}

final class AuthSigninState extends AuthState {}

final class AuthSignupState extends AuthState {}

final class AuthOtpState extends AuthState {
  final String phone;
  const AuthOtpState(this.phone);
}
final class AuthVerificationState extends AuthState {
  final String email;
  final bool backToLogin;
  const AuthVerificationState({
    required this.email,
    required this.backToLogin
});
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
  // TODO: implement props
  List<Object?> get props => [errorMsg];

}
final class ResetPasswordLoading extends AuthState {}

final class ResetPasswordSuccess extends AuthState {

}

final class ResetPasswordFailure extends AuthState {

  final String errorMsg;
  const ResetPasswordFailure(this.errorMsg);
  @override
  // TODO: implement props
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
  // TODO: implement props
  List<Object?> get props => [errorMsg];

}

final class GoogleLoading extends AuthState{

}
final class GoogleLoaded extends AuthState{

}
final class GoogleError extends AuthState{

  final String errorMsg;
  const GoogleError(this.errorMsg);
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

final class VerifyUserSuccess extends AuthState{
final bool isVerified;
const VerifyUserSuccess(
{
  this.isVerified=false
}
    );
}
final class VerifyUserFailed extends AuthState{
  final String errorMsg;
  const VerifyUserFailed(this.errorMsg);
  @override
  // TODO: implement props
  List<Object?> get props => [errorMsg];
}

final class ResendEmailSuccess extends AuthState{
  const ResendEmailSuccess();
}

final class ResendEmailFailiure extends AuthState{

  final String errorMsg;

  @override
  // TODO: implement props
  List<Object?> get props => [errorMsg];

  const ResendEmailFailiure(this.errorMsg);
}


