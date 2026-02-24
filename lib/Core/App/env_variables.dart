import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentVariableEnum{
  dev,
  prod
}

class EnvironmentVariable{

  EnvironmentVariable._();

  static final EnvironmentVariable instance=EnvironmentVariable._();

  String _environmentVariable='';

  Future<void>init(EnvironmentVariableEnum env)async{


switch(env){
  case EnvironmentVariableEnum.dev:await dotenv.load(fileName: '.env.dev');
  case EnvironmentVariableEnum.prod:await dotenv.load(fileName: '.env.prod');
}
_environmentVariable=dotenv.get("ENV_TYPE");

  }
  String get environmentVariable=> _environmentVariable;
}