import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/Navigation/custom_route_builder.dart';
import 'package:sekka/Core/Navigation/main_bottom_nav_view.dart';
import 'package:sekka/Features/Auth/Logic/set_up_profile_cubit.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/View/setup_profile_view.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/conversation.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/View/chat_screen.dart';
import 'package:sekka/Features/LostAndFound/View/conversation_screen.dart';
import 'package:sekka/Features/LostAndFound/View/item_detail_and_chat_screen.dart';
import 'package:sekka/Features/OnBoarding/Ui/Views/OnBoardingView.dart';
import '../../Features/Auth/Ui/auth_wrapper_view.dart';
import '../../Features/Splash/View/splash_screen_view.dart';
import '../Constants/app_route.dart';
import '../DI/service_locator.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  
  switch (settings.name) {

    case AppRoute.splash:
      return CustomPageRoute(page: SplashScreenView());

    case AppRoute.onBoarding:
      return CustomPageRoute(page: OnBoardingView());

    case AppRoute.authWrapper:
      return CustomPageRoute(page: AuthWrapper());

    case AppRoute.setUpProfile:
      return CustomPageRoute(
        page: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<SetUpProfileCubit>()),
            BlocProvider(create: (_) => getIt<PickImageCubit>()),
          ],
          child: SetupProfileView(),
        ),
      );

case AppRoute.chat:
   final args = settings.arguments as Map<String, dynamic>;
  return CustomPageRoute(
    
    page: BlocProvider(
      create: (context) => getIt<ChatCubit>(),
      child: ChatScreen(
        conversation: args['conversationId'] as Conversation?,
        otherUserId: args['userId'] as String,
        item: args['postData'] as ItemModel?,
      ),
    ),
  );



      case AppRoute.itemDetailAndChatScreen:
      return CustomPageRoute(
        page: BlocProvider.value(
          value: settings.arguments as LostAndFoundCubit,
          child: ItemDetailAndChatScreen(
                item: settings.arguments as ItemModel,
          ),
        )
      );
    case AppRoute.bottomNavigation:
      return CustomPageRoute(page: MainBottomNavView());

    default:
      return MaterialPageRoute(builder: (_) => SplashScreenView());
  }
}
