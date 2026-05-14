import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sekka/Core/App/env_variables.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Helper/bloc_observer_helper.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/firebase_options.dart';
import 'package:sekka/sekka.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Features/Auth/Data/Model/user_model.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  final instance=EnvironmentVariable.instance;
  await instance.init(EnvironmentVariableEnum.dev);
   init();
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

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TransportTypeAdapter());
  
  runApp(
  const Sekka()
  );
}


