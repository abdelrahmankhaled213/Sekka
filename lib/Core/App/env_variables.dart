import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentVariableEnum{
  dev,
  prod
}

class EnvironmentVariable{

  EnvironmentVariable._();

  static final EnvironmentVariable instance=EnvironmentVariable._();

  String _environmentVariable='';
  String _supabaseUrl='';
  String _supabaseKey='';
  String _clientId='';
  String _apiKeyMap='';
  Future<void>init(EnvironmentVariableEnum env)async{


switch(env){
  
  case EnvironmentVariableEnum.dev:
    {
      await dotenv.load(fileName: '.env.dev');
      break;
    }
  case EnvironmentVariableEnum.prod:{
    await dotenv.load(fileName: '.env.prod');
    break;
  }
}
_environmentVariable=dotenv.get("ENV_TYPE");
_supabaseUrl=dotenv.get('Supabase_Url');
_supabaseKey=dotenv.get('Supabase_Key');
_clientId=dotenv.get("GOOGLE_WEB_CLIENT_ID");
_apiKeyMap=dotenv.get("MAPS_API_KEY");

  }

  String get environmentVariable=> _environmentVariable;
  String get supabaseUrl=>_supabaseUrl;
  String get supabaseKey=>_supabaseKey;
  String get webClientId=> _clientId;
  String get apiKeyMap=>_apiKeyMap;
}