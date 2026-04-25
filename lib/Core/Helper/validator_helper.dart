import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/app_regex_helper.dart';

abstract class ValidatorHelper {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppText.emailIsEmpty;
    }
    if (!AppRegex.isEmailValid(value)) {
      return AppText.emailIsNotValid;
    }
    return null;
  }

  static String? phone(String? value) {

    if (value == null || value.isEmpty) {
      return AppText.phoneIsEmpty;
    }
    if (!AppRegex.isPhoneNumberValid(value)) {
      return AppText.phoneIsNotValid;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppText.passwordIsEmpty;
    }
    if (value.length < 5) {
      return AppText.passwordIsTooShort;
    }
    if (!AppRegex.isPasswordValid(value)) {
      return AppText.passwordIsNotValid;
    }
    return null;
  }

  static String? custom(String? value, String? Function(String?) validator) {
    return validator(value);
  }
}
