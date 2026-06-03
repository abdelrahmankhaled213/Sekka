import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/validator_helper.dart';
import 'package:sekka/core/theme/app_colors.dart';
import 'package:sekka/core/theme/app_radius.dart';
import 'package:sekka/core/theme/app_spacing.dart';
import 'package:sekka/core/theme/app_text_styles.dart';
import 'package:sekka/core/widgets/app_button.dart';
import 'package:sekka/core/widgets/app_loading.dart';
import '../../../../../Core/Helper/animation_helper.dart';
import '../../../../../Core/Helper/toast_helper.dart';
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
  late final TextEditingController passwordController;
  late final AnimationController animationController;
  late final Animation<Offset>slideAnimationEmailOrPhone;
  late final Animation<Offset>password;
  final GlobalKey<FormState>globalKey = GlobalKey<FormState>();

  bool isSubmit=false;


  bool _localizedSlideAnimationsReady = false;

  @override
  void initState() {

    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();

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
      super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Form(

      key: globalKey,

      autovalidateMode:
      isSubmit ? AutovalidateMode.always : AutovalidateMode.disabled,

  child: Padding(
          padding: AppSpacing.horizontalLG,
          child: Container(
              padding: EdgeInsets.all(AppSpacing.xxxl.sp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.allXXL
              ),
              child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // PhoneOrEmail(method: method, onChanged: (value) {
                    //   setState(() {
                    //     method = value;
                    //     if (method == SignUpMethod.email) {
                    //       phoneController.clear();
                    //     } else {
                    //       emailController.clear();
                    //     }
                    //   });



                    // },),

                    // SizedBox(height: AppSpacing.xxl.h),

                    SlideTransition(
                      position: slideAnimationEmailOrPhone,
                      child: InputField(
                          validator: _validateEmailOrPhone,
                          titleName:
                         AppText.emailAddress 
                          ,
                          hint: AppText.enterYourEmail
                          ,
                          controller: 
                               emailController
                              
                          ,
                          prefixIcon:
                          Icon( Icons.mail 
                            , size: 20.sp, color: AppColors.grey)),
                    ),

  SizedBox(height: AppSpacing.md.h),

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
                          Icon(Icons.lock, size: 20.sp, color: AppColors.grey,),
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


  SizedBox(height: AppSpacing.xl.h),

   GestureDetector(
                  onTap: () => context.read<AuthCubit>().navigateToForgotPassword(),
                  child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(AppText.forgotPassword, style: AppTextStyles.labelMedium(context).copyWith(color: AppColors.primary)),
                      ),
                ) ,
           
              SizedBox(height: AppSpacing.lg.h),


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

                              FlutterToastHelper.showToast(text: state.errorMsg, color: AppColors.error);
                            
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
                                     color: AppColors.success
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
                                      text: state.errorMsg,
                                      color: AppColors.error
                                  );
                                }
                           
                                if (state is LoginSuccess) {
                               context.read<AuthCubit>().isVerifiedUser();
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
                                    ? const AppLoading(variant: AppLoadingVariant.circular)
                                    : Align(
                                  child: AppButton(

                                    text: AppText.signIn,
                                    variant: AppButtonVariant.gradient,
                                    size: AppButtonSize.large,
                                    fullWidth: true,
                                    isLoading: state is LoginLoading,
                                    onPressed: () async {
                                      setState(() {
                                        isSubmit = true;
                                      });
                                      if (globalKey.currentState!.validate()) {
                                        final signUpRequest = SignInRequest(
                                          email: 
                                               emailController.text,
                                              
                                          password: passwordController.text,
                                        );
                                        await BlocProvider.of<AuthCubit>(context)
                                            .login(signUpRequest);
                                      }
                                    },
                                  ),
                                );
                           
                                                   }
                                                 ),
                           ),
                         ),

                    SizedBox(height: AppSpacing.xxl.h),

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

     return  ValidatorHelper.email(value);
        
  }

  String? _validatePassword(String? value) {

    return ValidatorHelper.password(value,);
  }
}
