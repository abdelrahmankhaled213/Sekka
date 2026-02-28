import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/animation_helper.dart';
import 'package:sekka/Core/Widget/custom_button_core.dart';
import 'package:sekka/Core/Widget/custom_text_field.dart';
import 'package:sekka/Features/Register/Ui/Widget/password_restriction.dart';
import 'package:sekka/Features/Register/Ui/Widget/terms_and_condition.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Helper/app_regex_helper.dart';

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
   late final TextEditingController nameController;
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
   List<BoxShadow>get shadow=>[

     BoxShadow(
         color: Colors.black.withOpacity(0.2),
         offset: Offset(0, 4),
         blurRadius: 6.r,
         spreadRadius: -1.r

     ),

     BoxShadow(
         color: Colors.black.withOpacity(0.2),
         offset: Offset(0,2),
         blurRadius: 4.r,
         spreadRadius: -2.r
     )

   ];

  @override
  void initState() {

    super.initState();

    nameController=TextEditingController();
    emailController=TextEditingController();
    passwordController=TextEditingController();
    confirmPasswordController=TextEditingController();
    phoneController=TextEditingController();
    passwordController.addListener(_passwordListener);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds:3),
    );

    choosePhoneOrEmail=AnimationHelper.buildAnimation(start: 0.0
        , end: 0.2, animationController: animationController
        , tween: _refactorTween());

    slideAnimationName = AnimationHelper
        .buildAnimation<Offset>(start:
    0.1, end: 0.3
        , animationController: animationController
        , tween: _refactorTween()
    );


slideAnimationEmailOrPhone=AnimationHelper.buildAnimation<Offset>(
    start: 0.2 , end: 0.4
    , animationController: animationController
    , tween: _refactorTween()
);

   password=AnimationHelper.buildAnimation<Offset>(
        start: 0.3 , end: 0.5
        , animationController: animationController
        , tween: _refactorTween()
    );

    confirmPassword=AnimationHelper.buildAnimation<Offset>(
        start: 0.4 , end: 0.6
        , animationController: animationController
        , tween: _refactorTween()
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

    nameController.dispose();
    emailController.dispose();
    passwordController.removeListener(_passwordListener);
    passwordController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();

    super.dispose();

}

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding:  EdgeInsets.symmetric(horizontal: 16.w),

      child: Container(

        padding: EdgeInsets.all(33.sp),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r)
        ),
        child:    Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPhoneOrEmail(),
               SizedBox(
                 height: 24.h,
                              ),
                  SlideTransition(
                  position: slideAnimationName,
                  child: _buildInputField(titleName: AppText.fullName
                      , hint: AppText.enterYourName, controller: nameController
                      ,prefixIcon: Icon(Icons.person,size: 20.sp,color: AppColor.grey,)),
                ),

                SlideTransition(
                  position: slideAnimationEmailOrPhone,
                  child: _buildInputField(
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
                child: _buildInputField(titleName:
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
                child: _buildInputField(
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

              _buildAllPasswordRestrictions(),

              SizedBox(
                height: 20.h,
              ),

              TermsAndConditions(text: AppText.iAgreeToThe
                , text2: AppText.termsOfService,),

              TermsAndConditions(text: AppText.and
                , text2: AppText.privacyPolicy,),

              SizedBox(
                height: 16.h,
              ),
      CustomButtonCore(onPressed: (){}, width: 274.w, height: 56.h
          , firstColor: AppColor.main, secondColor: AppColor.secondary
          ,thirdColor: AppColor.pink
          , text: AppText.createAccount, child: Center(
      child: Text(AppText.createAccount,
        style: AppStyle.regular18RobotoWhite.copyWith(
        fontSize: 16.sp,

      ),),
          ))
            ] )
      ),
    );
  }
Tween<Offset> _refactorTween(){
    return Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    );
}
  Widget _buildAllPasswordRestrictions(){
    return Column(

      children: [

        PasswordRestriction(text: AppText.validationTextLength
          , hasValidated: appRegexUpdates.minLength,),

        SizedBox(
          height: 3.h,
        ),

        PasswordRestriction(text: AppText.validationLowerCase
          , hasValidated: appRegexUpdates.isLowerCase,),

        SizedBox(
          height: 3.h,
        ),

        PasswordRestriction(text: AppText.validationUpperCase
          , hasValidated: appRegexUpdates.isUpperCase,),

        SizedBox(
          height: 3.h,
        ),

        PasswordRestriction(text: AppText.validationNumber
          , hasValidated: appRegexUpdates.hasNumber,),


        SizedBox(
          height: 3.h,
        ),

        PasswordRestriction(text: AppText.validationSpecialCharacter
          , hasValidated: appRegexUpdates.isSpecialCharacter,),

      ],
    );
  }
  Widget _buildInputField({
    required String titleName,
    required String hint,
    required TextEditingController controller,
    bool? isObscureText,
    Widget? prefixIcon,
    Widget? suffixIcon
}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(titleName
        ,style: AppStyle.regular16RobotoBlack,),
      SizedBox(
        height: 8.h,
      ),
      MyTextFormField(controller: controller
        ,  hint: hint,backGroundColor: AppColor.customWhite,
        prefixIcon: prefixIcon,icon: suffixIcon
        ,obscureText: isObscureText,),
      SizedBox(
        height: 16.h,
      ),

    ],
  );
  }
  Widget _buildPhoneOrEmail(){
    return Container(
        padding: EdgeInsets.all(4.sp),
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.circular(16.r),
          color: AppColor.offWhite,
        ),
        height: 80.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildOption(value: SignUpMethod.email,text: AppText.email,icon: Icons.mail
                ,),
            ),
            Expanded(
              child: _buildOption(value: SignUpMethod.phone,icon: Icons.phone
                ,text: AppText.phone,),
            ),

          ],
        )

    );

  }
  Widget _buildOption({required SignUpMethod value,required String text
    ,required IconData icon
    }){

    final isSelected=value==method;

    return GestureDetector(
      onTap:() {
        setState(() {
          method=value;
        });
      },
      child: Container(
          height: 72.h,
          width: 140.w,
          decoration: BoxDecoration(
            boxShadow: isSelected?shadow:null,
              color: isSelected ? Colors.white : AppColor.offWhite,
              borderRadius: BorderRadius.circular(16.r),
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(icon,size: 20.sp,color: isSelected?AppColor.main:AppColor.grey,),
             SizedBox(
              height: 8.h,
             ),
            Text(text
              ,style: isSelected?AppStyle.regular16RobotoGrey.copyWith(
                    color: AppColor.main
                ):AppStyle.regular16RobotoGrey
            )
          ],
        ),
      ),
    );

  }
}
