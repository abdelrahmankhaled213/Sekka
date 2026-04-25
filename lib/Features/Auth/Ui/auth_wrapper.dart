import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Helper/animation_helper.dart';
import 'package:sekka/Features/Auth/Ui/ForgotPassword/View/forgot_password_view.dart';
import 'package:sekka/Features/Auth/Ui/VerifyEmail/View/verify_email.dart';
import '../Logic/auth_cubit.dart';
import '../Logic/auth_state.dart';
import 'Login/View/login_view.dart';
import 'Login/View/otp_view.dart';
import 'Register/View/register_screen_view.dart';

class AuthFlowView extends StatelessWidget {

  const AuthFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
      current is AuthSigninState ||
          current is AuthSignupState ||
          current is AuthOtpState ||
          current is AuthForgotPasswordState ||
          current is AuthVerificationState
      ,
      builder: (context, state) {

        return PopScope(
          canPop: state is AuthSigninState,
          onPopInvoked: (didPop) {

            if (didPop) return;

if(state is AuthSignupState){
context.read<AuthCubit>().navigateToSignIn();
}
if(state is AuthOtpState){
  context.read<AuthCubit>().navigateToSignIn();
}
if(state is AuthForgotPasswordState){
  context.read<AuthCubit>().navigateToSignIn();
}
if(state is AuthVerificationState && !state .backToLogin){
  context.read<AuthCubit>().navigateToSignUp();
}
if(state is AuthVerificationState && state.backToLogin){
  context.read<AuthCubit>().navigateToSignIn();
}

        },
          child: Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {

                final curved = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                );
                return FadeTransition(
                  opacity: curved,
                  child: SlideTransition(
                    position: AnimationHelper.slideTweenByContext(context).animate(curved),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(state.runtimeType),
                child: _buildPage(state),
              ),
            ),
          ),
        );
      },
    );
  }


   Widget _buildPage(AuthState state) {

    if (state is AuthSigninState) {
      return const LoginView();
    }

    if (state is AuthSignupState) {
      return const RegisterScreenView();
    }

    if (state is AuthOtpState) {
      return OtpView(phoneNumber: state.phone);
    }

    if (state is AuthForgotPasswordState) {
      return ForgotPasswordView();
    }

    if(state is AuthVerificationState){
      return VerifyEmailScreenView();
    }

    return const LoginView();
  }


}