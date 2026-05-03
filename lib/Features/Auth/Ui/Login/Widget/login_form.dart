import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/validator_helper.dart';
import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Helper/animation_helper.dart';
import '../../../../../Core/Helper/toast_helper.dart';
import '../../../../../Core/Widget/custom_button_core.dart';
import '../../../Data/Model/signInRequest.dart';
import '../../../Logic/auth_cubit.dart';
import '../../../Logic/auth_state.dart';
import '../../Register/Widget/input_field.dart';
import '../../Register/Widget/phone_or_email.dart';
import '../../Register/Widget/signup_form.dart';
import '../../Register/Widget/terms_and_condition.dart';

class LoginForm extends StatefulWidget {

  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {

  SignUpMethod method = SignUpMethod.email;
  bool isObscurePassword = true;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final AnimationController animationController;
  late final Animation<Offset>slideAnimationEmailOrPhone;
  late final Animation<Offset>password;
  final GlobalKey<FormState>globalKey = GlobalKey<FormState>();

  bool isSubmit=false;

  bool get isEmail => SignUpMethod.email == method;

  bool _localizedSlideAnimationsReady = false;

  @override
  void initState() {

    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
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

    password = AnimationHelper.buildLocalizedSlideAnimation(
      start: 0.3,
      end: 0.5,
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
    passwordController.dispose();
    phoneController.dispose();
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

                    PhoneOrEmail(method: method, onChanged: (value) {
                      setState(() {
                        method = value;
                        if (method == SignUpMethod.email) {
                          phoneController.clear();
                        } else {
                          emailController.clear();
                        }
                      });



                    },),

                    SizedBox(
                      height: 24.h,
                    ),


                    SlideTransition(
                      position: slideAnimationEmailOrPhone,
                      child: InputField(
                          validator: _validateEmailOrPhone,
                          titleName:
                          isEmail ? AppText.emailAddress : AppText.phoneNumber
                          ,
                          hint: isEmail ? AppText.enterYourEmail : AppText
                              .phoneNumber
                          ,
                          controller: isEmail
                              ? emailController
                              : phoneController
                          ,
                          prefixIcon:
                          Icon(isEmail ? Icons.mail : Icons.phone
                            , size: 20.sp, color: AppColor.grey,)),
                    ),

                    SizedBox(
                      height: 12.h,
                    ),

            SlideTransition(
                      position: password,
                      child: InputField(
                          validator: _validatePassword,
                          titleName:
                          AppText.password
                          ,
                          hint: AppText.enterYourPassword
                          ,
                          controller: passwordController,
                          prefixIcon:
                          Icon(Icons.lock, size: 20.sp, color: AppColor.grey,),
                          suffixIcon: IconButton(onPressed: () {
                            setState(() {
                              isObscurePassword = !isObscurePassword;
                            });
                          }, icon: Icon(isObscurePassword ? Icons.visibility
                              : Icons.visibility_off)
                          ),
                          isObscureText: isObscurePassword
                      ),
                    ),


                    SizedBox(
                      height: 15.h,
                    ),

                isEmail?    GestureDetector(
                  onTap: ()=>context.read<AuthCubit>()
                      .navigateToForgotPassword(),
                  child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(AppText.forgotPassword
                          , style: AppStyle.regular16RobotoGrey.copyWith(
                              fontSize: 14.sp,
                              color: AppColor.main
                          ),),
                      ),
                ):SizedBox(),


                    SizedBox(
                      height: 16.h,
                    ),


                         BlocListener<AuthCubit,AuthState>(
                          
                          listener: (context, state) {

                            if(state is GetProfileSuccess){

                              final isGetStarted=state.isGettingStarted;
                              
                              if(isGetStarted){
                                Navigator.pushReplacementNamed(context, AppRoute.setUpProfile);
                              }
                              else{
                                Navigator.pushReplacementNamed(context, AppRoute.bottomNavigation);
                              }
                            }

                            if(state is GetProfileError){

                              FlutterToastHelper.showToast(text: state.errorMsg,color: AppColor.error);
                            
                            }
                          
                          },
                          
                          listenWhen: (previous, current) {

                            return current is GetProfileSuccess ||
                                current is GetProfileError;
                          
                          },

                           child: BlocListener<AuthCubit,AuthState>(
                             
                             listener: (context, state) async {
                           
                               if(state is VerifyUserSuccess && state.isVerified){
                           
                                 FlutterToastHelper.showToast(
                                     text: AppText.signInSuccessfully,
                                     color: AppColor.success
                                 );
                           
                               await context.read<AuthCubit>().getProfile();
                              
                               }
                           
                               else{
                                 context.read<AuthCubit>()
                                     .navigateToVerifyEmail(email: emailController.text , isBackToLogin: true);
                           
                               }
                             },
                           
                             listenWhen: (previous, current) {
                           
                               return current is VerifyUserSuccess ||
                               current is VerifyUserFailed;
                           
                               },
                           
                             child: BlocConsumer<AuthCubit, AuthState>(
                           
                              listener: (context, state) {
                                if (state is LoginFailure) {
                                  FlutterToastHelper.showToast(
                                      text: state.errorMsg
                                      ,color: AppColor.error
                                  );
                                }
                           
                                if (state is LoginSuccess) {
                                                   
                                if(!isEmail) {
                                 context.read<AuthCubit>().navigateToOtpState(phoneController.text);
                                                                                                  }
                             else{
                               context.read<AuthCubit>().isVerifiedUser();
                               }
                           
                                }
                           
                              },
                              listenWhen: (previous, current) {
                                return current is LoginSuccess ||
                                    current is LoginFailure;
                              },
                           
                              buildWhen: (previous, current) {
                                return current is LoginLoading
                                    || current is LoginSuccess
                                    || current is LoginFailure;
                              },
                           
                              builder: (context, state) {
                                return state is LoginLoading
                                    ? CircularProgressIndicator(
                                  color: AppColor.main,
                                ) : Align(
                                  child: CustomButtonCore(onPressed: () async {
                           
                                    setState(() {
                                      isSubmit = true;
                                    });
                                    if (globalKey.currentState!.validate()) {
                                      final signUpRequest = SignInRequest(
                                        email: isEmail
                                            ? emailController.text
                                            : null,
                                        phone: isEmail ? null : phoneController
                                            .text,
                                        password: passwordController.text,
                                      );
                           
                                      await BlocProvider.of<AuthCubit>(context)
                                          .login(signUpRequest);
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
                                      text: AppText.signIn,
                                      child: Center(
                                          child: Text(AppText.signIn,
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
                           ),
                         ),

                    SizedBox(
                      height: 24.h,
                    ),
                    Center(child: CustomTextSpan(text: AppText.dontHaveAnAccount
                      , text2: AppText.signUp, onTapGesture: ()=>
                      context.read<AuthCubit>().navigateToSignUp()
                      ,))

                  ])
          )
      ),
    );
  }


  String? _validateEmailOrPhone(String? value) {
     return isEmail ? ValidatorHelper.email(value,)
        : ValidatorHelper.phone(value);
  }

  String? _validatePassword(String? value) {

    return ValidatorHelper.password(value,);
  }
}
