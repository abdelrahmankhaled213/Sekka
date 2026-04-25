import 'dart:ui';

import 'package:bloc/bloc.dart';

class LocaleCubit extends Cubit<Locale> {

  LocaleCubit() : super(const Locale('en'));

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  void setEnglish() => emit(english);

  void setArabic() => emit(arabic);

  void setLocale(Locale locale) => emit(locale);

  void toggleLanguage() {

    emit(state.languageCode == arabic.languageCode ? english : arabic);

  }
}
