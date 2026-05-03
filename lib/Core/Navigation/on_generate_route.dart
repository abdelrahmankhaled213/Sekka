import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Navigation/custom_route_builder.dart';
import 'package:sekka/Core/Navigation/main_bottom_nav_view.dart';
import 'package:sekka/Features/Auth/Logic/set_up_profile_cubit.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/View/setup_profile_view.dart';
import 'package:sekka/Features/Auth/Ui/auth_wrapper_view.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/View/item_detail_and_chat_screen.dart';
import 'package:sekka/Features/OnBoarding/Ui/Views/OnBoardingView.dart';
import '../../Features/Splash/View/splash_screen_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case AppRoute.splash:
        return CustomPageRoute(page: const SplashScreenView());

      case AppRoute.onBoarding:
        return CustomPageRoute(page: const OnBoardingView());

      case AppRoute.authWrapper:
        return CustomPageRoute(page: const AuthWrapper());

      case AppRoute.setUpProfile:
        return CustomPageRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<SetUpProfileCubit>()),
              BlocProvider(create: (context) => getIt<PickImageCubit>()),
            ],
            child: const SetupProfileView(),
          ),
        );

      case AppRoute.bottomNavigation:
        return CustomPageRoute(page: const MainBottomNavView());

      case AppRoute.itemDetailAndChatScreen:
      
if (arguments is Map<String, dynamic>) {
    return CustomPageRoute(
      page: BlocProvider(
create: (context) {
  return getIt<LostAndFoundCubit>();
},    
        child: ItemDetailAndChatScreen(
          item: arguments['item'] as ItemModel?,
          id: arguments['id'] as int?,
        ),
      ),
    );
  }      
       else if (arguments is int) {
          return CustomPageRoute(
            page: BlocProvider(
              create: (context) => getIt<LostAndFoundCubit>(),
              child: ItemDetailAndChatScreen(id: arguments , item: null),
            ),
          );
        
        }
        
        return MaterialPageRoute(builder: (_) => const SplashScreenView());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreenView());
    }
  }