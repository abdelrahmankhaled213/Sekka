import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sekka/Core/App/env_variables.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Helper/bloc_observer_helper.dart';
import 'package:sekka/sekka.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final instance=EnvironmentVariable.instance;
  await instance.init(EnvironmentVariableEnum.dev);
  setUpServiceLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Bloc.observer=MyBlocObserver();
  runApp(const Sekka());
}


