import 'package:flutter/material.dart';
import 'package:sekka/Core/App/env_variables.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/sekka.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final instance=EnvironmentVariable.instance;
  await instance.init(EnvironmentVariableEnum.dev);
  setUpServiceLocator();
  runApp(const Sekka());
}


