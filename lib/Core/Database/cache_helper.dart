import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{

final SharedPreferences sharedPreferences;

CacheHelper(this.sharedPreferences);

Future<void>setCachedValue({required String key ,required dynamic value}) async {

  if(value is int){
  await sharedPreferences.setInt(key, value);
}
else if(value is String){
  await sharedPreferences.setString(key, value);
}
else if(value is bool){
    await sharedPreferences.setBool(key, value);
  }
else if(value is double ){

    await sharedPreferences.setDouble(key, value);
  }
else if (value is List<String>){
  await sharedPreferences.setStringList(key, value);
  }else{
  throw Exception("UnSupported Type");
  }
}
dynamic getCachedValue(String key)async{

  return sharedPreferences.get(key);
}

Future<void> removeValue(String key) async {
  await sharedPreferences.remove(key);
}

Future<void> clearAll() async {
  await sharedPreferences.clear();
}
}

