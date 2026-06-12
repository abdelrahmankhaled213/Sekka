import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sekka/Core/Helper/notification_helper.dart';
import 'package:sekka/Core/Localization/app_localizations.dart';
import 'package:sekka/Core/Localization/locale_cubit.dart';
import 'package:sekka/Core/Navigation/on_generate_route.dart';
import 'package:sekka/core/theme/app_theme.dart';

class Sekka extends StatelessWidget {

const Sekka({super.key});

@override
Widget build(BuildContext context) {

  return ScreenUtilInit(
     designSize: Size(394, 853),
     splitScreenMode: true,

     builder: (context, child) {
return GestureDetector(

  behavior:HitTestBehavior.translucent ,

  onTap: _onTapMaterialApp,

  child: BlocProvider(

    create: (_) => LocaleCubit(),

    child: BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.lightTheme(context),
           themeMode: ThemeMode.light,
        debugShowCheckedModeBanner:false,
  
          title: 'Sekka',

   navigatorKey: navigatorKey,
   onGenerateRoute: onGenerateRoute,
          
          );
      },
    ),
  ),
);
    },
  );
}

void _onTapMaterialApp(){
  FocusManager.instance.primaryFocus?.unfocus();
}
}
