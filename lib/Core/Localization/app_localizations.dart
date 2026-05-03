import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {

  AppLocalizations._(
    this.locale,
    this._strings, {
    required bool publishActive,
  }) {
    if (publishActive) {
      _active = this;
    }
  }

  final Locale locale;
  final Map<String, String> _strings;

  static AppLocalizations? _active;
  static AppLocalizations? _englishOnly;
  static Map<String, String>? _embeddedEnglishMap;

  static Map<String, String> get _englishDefaults {

    _embeddedEnglishMap ??= Map<String, String>.from(
      json.decode(_embeddedEnglishJson) as Map<String, dynamic>,
    );

    return _embeddedEnglishMap!;
  }

  static AppLocalizations get effective {

    if (_active != null) {
      return _active!;
    }

    _englishOnly ??= AppLocalizations._(
      const Locale('en'),
      _englishDefaults,
      publishActive: false,
    );

    return _englishOnly!;
  }


  static AppLocalizations of(BuildContext context) {
    final result = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(result != null, 'AppLocalizations not found — add AppLocalizationsDelegate');
    return result!;
  }

  static Future<AppLocalizations> load(Locale locale) async {
    final name = locale.languageCode == 'ar' ? 'arabic' : 'english';
    final raw = await rootBundle.loadString('assets/locales/$name.json');
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final map = decoded.map((k, v) => MapEntry(k, v.toString()));

    return AppLocalizations._(locale, map, publishActive: true);

  }

  String _value(String key) => _strings[key]
      ?? _englishDefaults[key] ?? key;
  String get sameStation => _value('sameStation');
  String get skip => _value('skip');        
  String get save=> _value('save');    
  String get editProfile=> _value('editProfile');      
  String get sekkaMember=> _value('sekkaMember');
  String get logOut => _value('logOut');    
  String get aboutUs => _value('aboutUs');
  String get language => _value('language');
  String get englishLanguage => _value('englishLanguage');
  String get arabicLanguage => _value('arabicLanguage');
  String get recentTrips => _value('recentTrips');
  String get seeAll => _value('seeAll');
  String get totalTrips => _value('totalTrips');
  String get completed => _value('completed');
  String get totalSpent => _value('totalSpent');
  String get settings => _value('settings');
  String get helpAndSupport => _value('helpAndSupport');
  String get onLabel => _value('onLabel');
  String get offLabel => _value('offLabel');
  String get guestUser => _value('guestUser');
  String get notificationsTitle => _value('notificationsTitle');
  String get profile => _value('profile');
  String get journeyDetails => _value('journeyDetails');
  String get selectTransport => _value('selectTransport');
  String get planYourRoute => _value('planYourRoute');
  String get bestPathDestination => _value('bestPathDestination');
  String get startAndEndCantBeTheSame => _value('startAndEndCantBeTheSame');
  String get selectMetroStart=> _value('selectMetroStart');
  String get selectMetroEnd=> _value('selectMetroEnd');
  String get appName => _value('appName');
  String get search => _value('search');
  String get loading => _value('loading');
  String get selectItem => _value('selectItem');
  String get maxAttemptsForVerf => _value('maxAttemptsForVerf');
  String get resendEmailIn => _value('resendEmailIn');
  String get iHaveVerifiedMyEmail => _value('iHaveVerifiedMyEmail');
  String get resendEmailVerification => _value('resendEmailVerification');
  String get checkYourInBox => _value('checkYourInBox');
  String get clickYourVerificationLink => _value('clickYourVerificationLink');
  String get receiveEmail => _value('receiveEmail');
  String get checkYourSpam => _value('checkYourSpam');
  String get makeSureYourEmailIsCorrect => _value('makeSureYourEmailIsCorrect');
  String get waitFewMinutes => _value('waitFewMinutes');
  String get signInSuccessfully => _value('signInSuccessfully');
  String get backToLogin => _value('backToLogin');
  String get createAccount => _value('createAccount');
  String get joinSekkaAndTravelSmart => _value('joinSekkaAndTravelSmart');
  String get phone => _value('phone');
  String get email => _value('email');
  String get fullName => _value('fullName');
  String get phoneNumber => _value('phoneNumber');
  String get emailAddress => _value('emailAddress');
  String get password => _value('password');
  String get confirmPassword => _value('confirmPassword');
  String get enterYourName => _value('enterYourName');
  String get enterYourEmail => _value('enterYourEmail');
  String get enterYourPhoneNumber => _value('enterYourPhoneNumber');
  String get enterYourPassword => _value('enterYourPassword');
  String get enterYourConfirmPassword => _value('enterYourConfirmPassword');
  String get passwordMustContain => _value('passwordMustContain');
  String get validationSpecialCharacter => _value('validationSpecialCharacter');
  String get validationUpperCase => _value('validationUpperCase');
  String get validationLowerCase => _value('validationLowerCase');
  String get validationTextLength => _value('validationTextLength');
  String get validationNumber => _value('validationNumber');
  String get validationPhone => _value('validationPhone');
  String get iAgreeToThe => _value('iAgreeToThe');
  String get termsOfService => _value('termsOfService');
  String get and => _value('and');
  String get privacyPolicy => _value('privacyPolicy');
  String get alreadyHaveAnAccount => _value('alreadyHaveAnAccount');
  String get verifiedEmail => _value('verifiedEmail');
  String get signIn => _value('signIn');
  String get welcomeToSekka => _value('welcomeToSekka');
  String get smartTransportation => _value('smartTransportation');
  String get forgotPassword => _value('forgotPassword');
  String get dontHaveAnAccount => _value('dontHaveAnAccount');
  String get signUp => _value('signUp');
  String get verifyPhoneNumber => _value('verifyPhoneNumber');
  String get verifyEmail => _value('verifyEmail');
  String get verifyEmailTitle => _value('verifyEmailTitle');
  String get sentVerificationEmail => _value('sentVerificationEmail');
  String get verificationFailed => _value('verificationFailed');
  String get enterVerificationCode => _value('enterVerificationCode');
  String get send6DigitCode => _value('send6DigitCode');
  String get otpInstruction => _value('otpInstruction');
  String get emailIsEmpty => _value('emailIsEmpty');
  String get emailIsNotValid => _value('emailIsNotValid');
  String get passwordIsEmpty => _value('passwordIsEmpty');
  String get phoneIsEmpty => _value('phoneIsEmpty');
  String get phoneIsNotValid => _value('phoneIsNotValid');
  String get passwordIsNotValid => _value('passwordIsNotValid');
  String get passwordIsTooShort => _value('passwordIsTooShort');
  String get connectionTimeOut => _value('connectionTimeOut');
  String get sendTimeOut => _value('sendTimeOut');
  String get receiveTimeOut => _value('receiveTimeOut');
  String get badRequest => _value('badRequest');
  String get unauthorized => _value('unauthorized');
  String get forbidden => _value('forbidden');
  String get notFound => _value('notFound');
  String get internalServerError => _value('internalServerError');
  String get somethingWentWrong => _value('somethingWentWrong');
  String get cancel => _value('cancel');
  String get connectionError => _value('connectionError');
  String get unExpectedError => _value('unExpectedError');
  String get passwordRecoveryText => _value('passwordRecoveryText');
  String get passwordHelpYou => _value('passwordHelpYou');
  String get backToSignUp => _value('backToSignUp');
  String get completeYourProfile => _value('completeYourProfile');
  String get helpUsPersonalizeYourSekkaExperience =>
      _value('helpUsPersonalizeYourSekkaExperience');
  String get tellUsAboutYourSelf => _value('tellUsAboutYourSelf');
  String get letsStartWithTheBasics => _value('letsStartWithTheBasics');
  String get profilePicture => _value('profilePicture');
  String get yourProfileHelpUsProvide => _value('yourProfileHelpUsProvide');
  String get personalizedRouteSuggestionsAnd => _value('personalizedRouteSuggestionsAnd');
  String get notifications => _value('notifications');
  String get continuee => _value('continuee');
  String get orContinueWith => _value('orContinueWith');
  String get signInWithGoogle => _value('signInWithGoogle');
  String get verifyCode => _value('verifyCode');
  String get verificationSuccess => _value('verificationSuccess');
  String get phoneVerifiedSuccessfully => _value('phoneVerifiedSuccessfully');
  String get secureVerification => _value('secureVerification');
  String get secureVerificationDesc => _value('secureVerificationDesc');
  String get home => _value('home');
  String get trips => _value('trips');
  String get alerts => _value('alerts');
  String get comingSoon => _value('comingSoon');
  String get featureUnderPreparation => _value('featureUnderPreparation');
  String get preferredTransport => _value('preferredTransport');
  String get selectYourFavModeOfTransportation =>
      _value('selectYourFavModeOfTransportation');
  String get invalidPhoneNumber => _value('invalidPhoneNumber');
  String get invalidLogin => _value('invalidLogin');
  String get userNotFound => _value('userNotFound');
  String get wrongPassword => _value('wrongPassword');
  String get emailAlreadyExists => _value('emailAlreadyExists');
  String get weakPassword => _value('weakPassword');
  String get invalidOtpCode => _value('invalidOtpCode');
  String get otpExpired => _value('otpExpired');
  String get tooManyAttemptsTryLater => _value('tooManyAttemptsTryLater');
  String get networkErrorShort => _value('networkErrorShort');

  static const String _embeddedEnglishJson = r'''
{"maxAttemptsForVerf":"You have reached your max attempts" 
,"resendEmailIn":"Resend available in " ,"appName":"Sekka","search":"Search...","iHaveVerifiedMyEmail":"i've verified my email","resendEmailVerification":"Resend Email Verification","selectItem":"Select Item","checkYourInBox":"Check your inbox","clickYourVerificationLink":"Click the verification link in the email to activate your account.","receiveEmail":"Didn't receive the email ?","checkYourSpam":". Check your spam or junk folder","makeSureYourEmailIsCorrect":". Make sure your email is correct","waitFewMinutes":". Wait a few minutes for the email to arrive","signInSuccessfully":"Sign In Successfully","backToLogin":"Back to login","createAccount":"Create Account","joinSekkaAndTravelSmart":"Join Sekka and travel smart ","phone":"Phone","email":"Email","fullName":"Full Name","phoneNumber":"Phone Number","emailAddress":"Email Address","password":"Password","confirmPassword":"Confirm Password","enterYourName":"Enter your full name","enterYourEmail":"Enter your email","enterYourPhoneNumber":"Enter your phone number","enterYourPassword":"Create a password","enterYourConfirmPassword":"Confirm your password","passwordMustContain":"Password must contain :","validationSpecialCharacter":"has at least 1 character","validationUpperCase":"has at least 1 uppercase letter","validationLowerCase":"has at least 1 lowercase letter","validationTextLength":"has at least 8 characters long","validationNumber":"has at least 1 number","validationPhone":"Is phone valid","iAgreeToThe":"I agree to the","termsOfService":"Terms of Service","and":"and","privacyPolicy":"Privacy Policy","alreadyHaveAnAccount":"Already have an account ?","verifiedEmail":"your email has been verified","signIn":"Sign In","welcomeToSekka":"Welcome to Sekka","smartTransportation":"Your smart transportation companion","forgotPassword":"Forgot Password ?","dontHaveAnAccount":"Don't have an account ?","signUp":"Sign up","verifyPhoneNumber":"Verify Phone Number","verifyEmail":"Please verify your email","verifyEmailTitle":"Verify your email","sentVerificationEmail":"We sent a verification link to","verificationFailed":"Verification failed","enterVerificationCode":"Enter verification code","send6DigitCode":"We sent a 6 digit code to","otpInstruction":"For your security,\nplease enter the code\nwe sent to your phone via SMS.","emailIsEmpty":"Email is empty","emailIsNotValid":"Email is not valid","passwordIsEmpty":"Password is empty","phoneIsEmpty":"Phone is empty","phoneIsNotValid":"Phone is not valid","passwordIsNotValid":"Password is not valid","passwordIsTooShort":"Password is too short","connectionTimeOut":"Connection time out","sendTimeOut":"Send timeout","receiveTimeOut":"Receive timeout","badRequest":"Bad Request","unauthorized":"Unauthorized","forbidden":"Forbidden","notFound":"Not found","internalServerError":"Not found","somethingWentWrong":"Something went wrong","cancel":"Request cancelled","connectionError":"No Internet Connection","unExpectedError":"Unexpected error","passwordRecoveryText":"We'll send you a verification code to reset your password. Make sure you have access to your email.","passwordHelpYou":"Don't worry, we'll help you recover it","backToSignUp":"Back to sign up","completeYourProfile":"Complete Your Profile","helpUsPersonalizeYourSekkaExperience":"Help us personalize your Sekka experience","tellUsAboutYourSelf":"Tell us about yourself","letsStartWithTheBasics":"Let's start with the basics","profilePicture":"Profile Picture (Optional)","yourProfileHelpUsProvide":"Your profile help us provide","personalizedRouteSuggestionsAnd":"Personalized route suggestions ","notifications":"and notifications","continuee":"Continue","preferredTransport":"Preferred Transport","selectYourFavModeOfTransportation":"Select your favourite modes of transportation","invalidPhoneNumber":"Invalid phone number","invalidLogin":"Invalid login","userNotFound":"User not found","wrongPassword":"Wrong password","emailAlreadyExists":"Email already exists","weakPassword":"Weak password","invalidOtpCode":"Invalid OTP code","otpExpired":"OTP expired","tooManyAttemptsTryLater":"Too many attempts, try later","networkErrorShort":"Network error","loading":"loading"}
''';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'en' || locale.languageCode == 'ar';

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant AppLocalizationsDelegate old) => false;

}

extension LocaleExtension on BuildContext{

AppLocalizations get l10n => AppLocalizations.of(this);

}