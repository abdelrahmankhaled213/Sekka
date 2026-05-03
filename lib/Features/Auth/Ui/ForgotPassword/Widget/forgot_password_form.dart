import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Helper/validator_helper.dart';
import 'package:sekka/Features/Auth/Ui/ForgotPassword/Widget/password_recovery_text.dart';
import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';
import '../../../../../Core/Helper/animation_helper.dart';
import '../../../../../Core/Helper/toast_helper.dart';
import '../../../../../Core/Widget/custom_button_core.dart';
import '../../../Logic/auth_cubit.dart';
import '../../../Logic/auth_state.dart';
import '../../Register/Widget/input_field.dart';
import '../../Register/Widget/signup_form.dart';

class ForgotPasswordForm extends StatefulWidget {

  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();

}

class _ForgotPasswordFormState extends State<ForgotPasswordForm>
    with SingleTickerProviderStateMixin {

  SignUpMethod method = SignUpMethod.email;
  bool isObscurePassword = true;
  late final TextEditingController emailController;

  late final AnimationController animationController;
  late final Animation<Offset>slideAnimationEmailOrPhone;
  final GlobalKey<FormState>globalKey = GlobalKey<FormState>();

  bool isSubmit=false;

  bool get isEmail => SignUpMethod.email == method;

  bool _localizedSlideAnimationsReady = false;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_localizedSlideAnimationsReady) return;
    _localizedSlideAnimationsReady = true;

    final languageCode = Localizations.localeOf(context).languageCode;

    slideAnimationEmailOrPhone = AnimationHelper.buildLocalizedSlideAnimation(
      start: 0.2,
      end: 0.4,
      animationController: animationController,
      languageCode: languageCode,
    );

    animationController.forward();
  }


  @override
  void dispose() {

    animationController.stop();
    animationController.dispose();
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Form(

      key: globalKey,

      autovalidateMode:
      isSubmit ? AutovalidateMode.always : AutovalidateMode.disabled,

      child: Padding(

          padding: EdgeInsets.symmetric(horizontal: 16.w),

          child: Container(

              padding: EdgeInsets.all(33.sp),

              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r)
              ),
              child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [


                    SlideTransition(
                      position: slideAnimationEmailOrPhone,
                      child: InputField(
                          validator: _validateEmailOrPhone,
                          titleName:
                           context.l10n.emailAddress,

                          hint:context.l10n.enterYourEmail
                          ,
                          controller:
                               emailController
                          ,
                          prefixIcon:
                          Icon( Icons.mail
                            , size: 20.sp, color: AppColor.grey,)),
                    ),

                    SizedBox(
                      height: 12.h,
                    ),

PasswordRecoveryText(),

                    SizedBox(
                      height: 15.h,
                    ),

                    BlocConsumer<AuthCubit, AuthState>(

                        listener: (context, state) {
                          if (state is ResetPasswordFailure) {
                            FlutterToastHelper.showToast(
                                text: state.errorMsg,color: AppColor.error
                            );
                          }

                          if (state is ResetPasswordSuccess) {
FlutterToastHelper.showToast(text: "Password is sent",color: AppColor.success);
                          }

                        },
                        listenWhen: (previous, current) {
                          return current is LoginSuccess ||
                              current is LoginFailure;
                        },

                        buildWhen: (previous, current) {
                          return current is ResetPasswordSuccess
                              || current is ResetPasswordFailure
                              || current is ResetPasswordLoading;
                        },

                        builder: (context, state) {
                          return state is ResetPasswordLoading
                              ?
                          Center(
                                child: CircularProgressIndicator(
                                    color: AppColor.main,
                                                          ),
                              )
                              : Align(
                            child: CustomButtonCore(onPressed: () async {
                              setState(() {
                                isSubmit = true;
                              });
                              if (globalKey.currentState!.validate()) {
                            await BlocProvider.of<AuthCubit>(context).resetPassword(emailController.text);
                              }
                            },

                                width: 274.w,
                                height: 56.h
                                ,
                                firstColor: AppColor.main,
                                secondColor: AppColor.secondary
                                ,
                                thirdColor: AppColor.pink
                                ,
                                text: context.l10n.createAccount,
                                child: Center(
                                    child: Text(context.l10n.signIn,
                                        style: AppStyle.regular18RobotoWhite
                                            .copyWith(
                                          fontSize: 16.sp,
                                        )
                                    )
                                )
                            ),
                          );

                        }
                    ),

                  ])
          )
      ),
    );
  }


  String? _validateEmailOrPhone(String? value) {
    return isEmail ? ValidatorHelper.email(value,)
        : ValidatorHelper.phone(value,);
  }

}
