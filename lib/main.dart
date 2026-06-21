import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sekka/Core/App/env_variables.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Helper/bloc_observer_helper.dart';
import 'package:sekka/Core/Helper/notification_helper.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Map/data/Logic/cubit/map_cubit.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';
import 'package:sekka/firebase_options.dart';
import 'package:sekka/sekka.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Features/Auth/Data/Model/user_model.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
   init();
  await ScreenUtil.ensureScreenSize();
  final instance=EnvironmentVariable.instance;
  await instance.init(EnvironmentVariableEnum.dev);
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Bloc.observer=MyBlocObserver();
  await Supabase.initialize(url: instance.supabaseUrl
      , anonKey: instance.supabaseKey,realtimeClientOptions: RealtimeClientOptions(
           eventsPerSecond: 10, 
      ));

    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await getIt<NotificationHelper>().init();
  await Hive.initFlutter();
  
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TransportTypeAdapter());
  Hive.registerAdapter(TripHistoryModelAdapter());
  runApp(
  BlocProvider(create: (context) {
    return getIt<MapCubit>()..initLocation();
  },child: const Sekka())
  );
}


