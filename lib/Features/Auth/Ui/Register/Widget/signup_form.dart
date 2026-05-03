import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/animation_helper.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Core/Helper/validator_helper.dart';
import 'package:sekka/Core/Widget/custom_button_core.dart';
import 'package:sekka/Features/Auth/Data/Model/signup_request.dart';
import 'package:sekka/Features/Auth/Logic/auth_cubit.dart';
import 'package:sekka/Features/Auth/Logic/auth_state.dart';
import 'package:sekka/Features/Auth/Ui/Register/Widget/terms_and_condition.dart';
import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Helper/app_regex_helper.dart';
import 'all_password_restrictions.dart';
import 'input_field.dart';

enum SignUpMethod{
  email,
  phone
}

class SignupForm extends StatefulWidget {

  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm>
    with SingleTickerProviderStateMixin {

   SignUpMethod method=SignUpMethod.email;
   bool isObscurePassword=true;
   bool isObscureConfirmPassword=true;
   bool isSubmit=false;
   bool checkPolicy=false;
   late final TextEditingController emailController;
   late final TextEditingController phoneController;
   late final TextEditingController  passwordController;
   late final TextEditingController  confirmPasswordController;
   late final AnimationController animationController;
   late final Animation<Offset>slideAnimationName;
   late final Animation<Offset>slideAnimationEmailOrPhone;
   late final Animation<Offset>password;
   late final Animation<Offset>confirmPassword;
   late final Animation<Offset>choosePhoneOrEmail;

   AppRegexUpdates appRegexUpdates=AppRegexUpdates();
   bool get isEmail=>SignUpMethod.email==method;

   final GlobalKey<FormState>globalKey=GlobalKey();

  bool _localizedSlideAnimationsReady = false;

  @override
  void initState() {

    super.initState();

    final cubit = context.read<AuthCubit>();

    emailController = TextEditingController(
      text: cubit.signUpEmail ?? '',
    );

    passwordController = TextEditingController(
      text: cubit.signUpPassword ?? '',
    );

    confirmPasswordController = TextEditingController(
      text: cubit.signUpConfirmPassword?? '',
    );

    phoneController=TextEditingController();
    passwordController.addListener(_passwordListener);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds:2),
    );

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_localizedSlideAnimationsReady) return;
    _localizedSlideAnimationsReady = true;

    final languageCode = Localizations.localeOf(context).languageCode;

    choosePhoneOrEmail = AnimationHelper.buildLocalizedSlideAnimation(
      start: 0.0,
      end: 0.2,
      animationController: animationController,
      languageCode: languageCode,
    );

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

    confirmPassword = AnimationHelper.buildLocalizedSlideAnimation(
      start: 0.4,
      end: 0.6,
      animationController: animationController,
      languageCode: languageCode,
    );

    animationController.forward();
  }


  void _passwordListener(){
    setState(() {

      appRegexUpdates= appRegexUpdates.copyWith(
          minLength: AppRegex.hasMinLength(passwordController.text),
          isSpecialCharacter: AppRegex.hasSpecialCharacter(passwordController.text),
          isUpperCase: AppRegex.hasUpperCase(passwordController.text),
          hasNumber:AppRegex.hasNumber(passwordController.text) ,
          isLowerCase: AppRegex.hasLowerCase(passwordController.text)
      );
    });

  }

  @override
  void dispose() {



    animationController.stop();
    animationController.dispose();
    emailController.dispose();
    passwordController.removeListener(_passwordListener);
    passwordController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final cubit=context.read<AuthCubit>();

    return Form(

      key: globalKey,
      autovalidateMode:  isSubmit ? AutovalidateMode.always : AutovalidateMode.disabled,

      child: Padding(

        padding:  EdgeInsets.symmetric(horizontal: 16.w),

            child: Container(
            padding: EdgeInsets.all(33.sp),
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r)
          ),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SlideTransition(
                    position: slideAnimationEmailOrPhone,
                    child: InputField(
                      onChanged: (value) {
                        context.read<AuthCubit>().signUpEmail=value;
                      },
                      validator: _validateEmail,
                        titleName:
                    isEmail?AppText.emailAddress:AppText.phoneNumber
                        , hint: isEmail?AppText.enterYourEmail:AppText.phoneNumber
                        , controller: isEmail?emailController:phoneController
                        ,prefixIcon:
                        Icon(isEmail?Icons.mail:Icons.phone
                          ,size: 20.sp,color: AppColor.grey,) ),
                  ),

                SlideTransition(
                  position: password,
                  child: InputField(
onChanged: (value) {
context.read<AuthCubit>().signUpPassword=value;
},
                  validator: _validatePassword
                  ,titleName:
                  AppText.password
                      , hint: AppText.enterYourPassword
                      , controller: passwordController,prefixIcon:
                      Icon(Icons.lock,size: 20.sp,color: AppColor.grey,),
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      isObscurePassword=!isObscurePassword;
                    });
                  }, icon: Icon(isObscurePassword?Icons.visibility
                      :Icons.visibility_off)
                  ),
                    isObscureText: isObscurePassword
                  ),
                ),

                SlideTransition(
                 position: confirmPassword,
                  child: InputField(
                    onChanged: (value) {

                      context.read<AuthCubit>().signUpConfirmPassword=value;

                    },
                    validator: _validateConfirmPassword,
                        titleName:
                        AppText.confirmPassword
                      , hint: AppText.enterYourConfirmPassword
                      , controller: confirmPasswordController
                      ,prefixIcon:
                      Icon(Icons.lock,size: 20.sp,color: AppColor.grey,),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          isObscureConfirmPassword=!isObscureConfirmPassword;
                        });
                      }, icon: Icon(isObscureConfirmPassword?Icons.visibility
                          :Icons.visibility_off)
                      ),
                      isObscureText: isObscureConfirmPassword
                  ),
                ),

                SizedBox(
                  height: 16.h,
                ),

                Text(AppText.passwordMustContain
                  ,style: AppStyle.regular16RobotoGrey.copyWith(
                  fontSize: 14.sp
                ),),

                SizedBox(
                  height: 6.h,
                ),

                AllPasswordRestrictions(appRegexUpdates: appRegexUpdates),

                SizedBox(
                  height: 20.h,
                ),
_agreeToPolicy(),
                SizedBox(
                  height: 16.h,
                ),

        BlocConsumer<AuthCubit,AuthState>(
          builder: (context, state) {
            return state is SignUpLoading ? Center(
              child: CircularProgressIndicator(
                color: AppColor.main,
              ),
            ) : Center(
                child: AnimatedOpacity(
                  opacity: checkPolicy ? 1 : 0.4,
                  duration: const Duration(
                      seconds: 1
                  ),
                  child: CustomButtonCore(
                      onPressed:
                    checkPolicy?  _onPressedSignUp:null
                      ,
                      width: 274.w,
                      height: 56.h
                      ,
                      firstColor:
                      AppColor.main
                      ,
                      secondColor: AppColor.secondary
                      ,
                      thirdColor: AppColor.pink
                      ,
                      text: AppText.createAccount,
                      child: Center(
                        child: Text(AppText.createAccount,
                          style: AppStyle.regular18RobotoWhite.copyWith(
                            fontSize: 16.sp,

                          ),),
                      )),
                )
            );
          },

          buildWhen: (previous, current) {

            return current is SignUpLoading
                || current is SignUpLoaded
               || current is SignUpError;
            
          },
          listener: (context, state) async {
            if(state is SignUpError){
              FlutterToastHelper.showToast(text: state.errorMsg,color: AppColor.error);
            }
            if(state is SignUpLoaded){

cubit.navigateToVerifyEmail(email: emailController.text,isBackToLogin: false);


            }

          },
          listenWhen: (previous, current) {
            return current is SignUpError
                || current is SignUpLoaded;
            },
        ),

                SizedBox(
                  height: 12.h,
                ),

                Center(
                  child: CustomTextSpan(text: AppText
                      .alreadyHaveAnAccount
                    , text2: AppText.signIn,onTapGesture: () {
                    cubit.clearData();
                      cubit.navigateToSignIn();
                    },
                  ),
                ),

              ] )
        ),
      ),
    );
  }




Widget _agreeToPolicy(){

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextSpan(text: AppText.iAgreeToThe
              , text2: AppText.termsOfService,),

            CustomTextSpan(text: AppText.and
              , text2: AppText.privacyPolicy,),
          ],
        ),

Transform.scale(
  scaleX: 1.2,
  scaleY: 1.2,
  child: Checkbox(
  side: BorderSide(
    color: AppColor.main
  )
  ,shape: RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(5.r),
    side: BorderSide(
      color: AppColor.main
    ),
  ),
      focusColor: AppColor.main,
      activeColor: AppColor.main,
      checkColor: Colors.white
      ,value: checkPolicy, onChanged: _onChanged),
)

      ]

  );
}

void _onChanged(bool? value){
    setState(() {
      checkPolicy=value!;

    });

}
   String? _validateEmail(String? value) {
     return ValidatorHelper.email(value );

   }

   String? _validatePassword(String? value) {

     return ValidatorHelper.password(value,);
   }


String? _validateConfirmPassword(String? value){

  return ValidatorHelper.password(value, );


  }

   void _onPressedSignUp()async{

   setState(() {
     isSubmit=true;
   });
    if(globalKey.currentState!.validate()){

if(passwordController.text!=confirmPasswordController.text){
  FlutterToastHelper.showToast(text: 'Password doesn\'t match confrim password',color: AppColor.error);
  return;
}

      final request=SignUpRequest(email:emailController.text
          , password: passwordController.text);

      await BlocProvider.of<AuthCubit>(context).signup(request);

    }
}

  }

